/*
 * SPDX-FileCopyrightText: 2026 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

package org.lineageos.settings.device.esimswitcher

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.os.SystemProperties
import android.telephony.TelephonyManager
import android.util.Log
import com.qti.extphone.Client
import com.qti.extphone.ExtPhoneCallbackListener
import com.qti.extphone.ExtTelephonyManager
import com.qti.extphone.QtiSimType
import com.qti.extphone.ServiceCallback

class EsimController private constructor(private val context: Context) {
    private var extTelephonyManager: ExtTelephonyManager? = null
    private var client: Client? = null
    @Volatile private var isConnected = false
    @Volatile private var expectedSim2Type = -1

    private val mainHandler = Handler(Looper.getMainLooper())
    private val pendingCallbacks = mutableListOf<(Boolean) -> Unit>()
    private var pendingBounce: Runnable? = null

    private val serviceCallback =
        object : ServiceCallback {
            override fun onConnected() {
                Log.d(TAG, "ExtTelephonyService connected")
                isConnected = true
                extTelephonyManager?.let {
                    client =
                        it.registerCallbackWithEvents(
                            context.packageName,
                            phoneCallbackListener,
                            intArrayOf(ExtPhoneCallbackListener.EVENT_ON_SIM_TYPE_CHANGED),
                        )
                }
            }

            override fun onDisconnected() {
                Log.d(TAG, "ExtTelephonyService disconnected")
                isConnected = false
                client = null
            }
        }

    private val phoneCallbackListener =
        object : ExtPhoneCallbackListener() {
            override fun onSimTypeChanged(simTypes: Array<QtiSimType>?) {
                if (simTypes == null || simTypes.size != 2) return

                val typeVal = simTypes[1].get()
                Log.d(TAG, "onSimTypeChanged: SIM2 is now $typeVal")

                SystemProperties.set(PROPERTY_ESIM_SWITCH, typeVal.toString())

                if (expectedSim2Type != -1) {
                    if (typeVal != expectedSim2Type) {
                        Log.w(TAG, "Modem reported $typeVal, expected $expectedSim2Type for in-flight toggle")
                    } else {
                        Log.d(TAG, "Toggle confirmed by modem, bouncing radio to apply")
                        bounceRadio()
                    }
                    expectedSim2Type = -1
                }
            }
        }

        private fun flushPendingCallbacks(success: Boolean) {
            val callbacks = synchronized(pendingCallbacks) {
                val copy = pendingCallbacks.toList()
                pendingCallbacks.clear()
                copy
            }
            callbacks.forEach { it(success) }
        }


        fun ensureBound(timeoutMs: Long = 5000, callback: (Boolean) -> Unit) {
        if (isConnected && client != null) {
            callback(true)
            return
        }

        synchronized(pendingCallbacks) { pendingCallbacks.add(callback) }

        val manager = extTelephonyManager ?: ExtTelephonyManager.getInstance(context)
        if (manager == null) {
            Log.e(TAG, "ExtTelephonyManager still unavailable")
            flushPendingCallbacks(success = false)
            return
        }
        extTelephonyManager = manager

        try {
            manager.connectService(serviceCallback)
        } catch (e: Exception) {
            Log.e(TAG, "connectService failed from ensureBound", e)
            flushPendingCallbacks(success = false)
            return
        }

        mainHandler.postDelayed({
            if (!isConnected) {
                Log.e(TAG, "ensureBound timed out after ${timeoutMs}ms")
                flushPendingCallbacks(success = false)
            }
        }, timeoutMs)
    }

    fun init() {
        Log.d(TAG, "init: Attempting to bind to ExtTelephony...")
        expectedSim2Type = SystemProperties.getInt(PROPERTY_ESIM_SWITCH, -1)
        ensureBound {success -> 
            if (success) Log.i(TAG, "Bind success")
        }
    }

    fun bounceRadio() {
        val tm = context.getSystemService(TelephonyManager::class.java)
        if (tm == null) {
            Log.e(TAG, "TelephonyManager is null, cannot bounce radio")
            return
        }

        try {
            Log.w(TAG, "Powering radio OFF")
            tm.requestRadioPowerOffForReason(TelephonyManager.RADIO_POWER_REASON_USER)
        } catch (e: Exception) {
            Log.e(TAG, "requestRadioPowerOffForReason failed", e)
            return
        }

        cancelPendingBounce() // avoid stacking multiple pending bounces

        val bounceBack = Runnable {
            pendingBounce = null
            val tm2 = context.getSystemService(TelephonyManager::class.java)
            if (tm2 == null) {
                Log.e(TAG, "TelephonyManager gone by bounce-back time, skipping")
                return@Runnable
            }
            try {
                Log.w(TAG, "Powering radio ON")
                tm2.clearRadioPowerOffForReason(TelephonyManager.RADIO_POWER_REASON_USER)
            } catch (e: Exception) {
                Log.e(TAG, "clearRadioPowerOffForReason failed", e)
            }
        }
        pendingBounce = bounceBack
        mainHandler.postDelayed(bounceBack, 3000)
    }

    private fun cancelPendingBounce() {
        pendingBounce?.let { mainHandler.removeCallbacks(it) }
        pendingBounce = null
    }

    fun getEsimEnabled(): Boolean {
        if (!isConnected) {
            // Fallback to reading the property if the service hasn't bound yet
            return SystemProperties.getInt(PROPERTY_ESIM_SWITCH, QtiSimType.SIM_TYPE_PHYSICAL) ==
                QtiSimType.SIM_TYPE_ESIM
        }
        val simTypes = extTelephonyManager?.currentSimType
        return simTypes?.size == 2 && simTypes[1].get() == QtiSimType.SIM_TYPE_ESIM
    }

    fun setEsimEnabled(isEnabled: Boolean) {
        Log.d(TAG, "setEsimEnabled: $isEnabled")
        if (!isConnected || client == null) {
            Log.e(TAG, "Cannot set eSIM, service disconnected.")
            return
        }

        val targetType = if (isEnabled) QtiSimType.SIM_TYPE_ESIM else QtiSimType.SIM_TYPE_PHYSICAL
        expectedSim2Type = targetType

        val config = arrayOf(QtiSimType(QtiSimType.SIM_TYPE_PHYSICAL), QtiSimType(targetType))
        try {
            extTelephonyManager?.setSimType(client, config)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to call setSimType", e)
            expectedSim2Type = -1
        }
    }

    companion object {
        private const val TAG = "NothingEsimController"
        private const val PROPERTY_ESIM_SWITCH = "persist.radio.nt.esim_switch"

        @Volatile private var instance: EsimController? = null

        fun getInstance(context: Context): EsimController {
            return instance
                ?: synchronized(this) {
                    instance ?: EsimController(context.applicationContext).also { instance = it }
                }
        }
    }
}
