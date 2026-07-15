/*
 * SPDX-FileCopyrightText: 2026 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

package org.lineageos.settings.esimswitcher

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
    private var isConnected = false
    private var expectedSim2Type = -1

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
                enforceCorrectState()
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

                // Sync hardware state to system property
                SystemProperties.set(PROPERTY_ESIM_SWITCH, typeVal.toString())

                // Prevent modem from reverting unexpectedly
                if (expectedSim2Type != -1 && typeVal != expectedSim2Type) {
                    Log.w(TAG, "Modem state ($typeVal) mismatch. Enforcing ($expectedSim2Type)")
                    enforceCorrectState()
                } else if (expectedSim2Type != -1) {
                    Log.w(TAG, "Config accepted. Bouncing radio to apply hardware switch.")
                    bounceRadio()

                    // Reset expected state so we don't bounce the radio on random modem events
                    expectedSim2Type = -1
                }
            }
        }

    fun init() {
        Log.d(TAG, "init: Binding ExtTelephony")
        expectedSim2Type = SystemProperties.getInt(PROPERTY_ESIM_SWITCH, -1)
        extTelephonyManager = ExtTelephonyManager.getInstance(context)
        extTelephonyManager?.connectService(serviceCallback)
    }
    
    fun bounceRadio() {
        val tm = context.getSystemService(TelephonyManager::class.java)
        if (tm == null) {
            Log.e(TAG, "TelephonyManager is null, cannot bounce radio")
            return
        }

        // Request a radio power off for the modem to apply new SIM state.
        Log.w(TAG, "Powering radio OFF")
        tm.requestRadioPowerOffForReason(TelephonyManager.RADIO_POWER_REASON_USER)

        // Wait 3 seconds for the baseband to tear down the connection, might not be needed ?
        Handler(Looper.getMainLooper()).postDelayed({
            Log.w(TAG, "Powering radio ON")
            tm.clearRadioPowerOffForReason(TelephonyManager.RADIO_POWER_REASON_USER)
        }, 3000)
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
        }
    }

    private fun enforceCorrectState() {
        if (expectedSim2Type == -1) return
        val currentTypes = extTelephonyManager?.currentSimType

        if (
            currentTypes != null &&
                currentTypes.size == 2 &&
                currentTypes[1].get() != expectedSim2Type
        ) {
            val config =
                arrayOf(QtiSimType(QtiSimType.SIM_TYPE_PHYSICAL), QtiSimType(expectedSim2Type))
            try {
                extTelephonyManager?.setSimType(client, config)
            } catch (e: Exception) {
                Log.e(TAG, "Failed to enforce correct SIM type", e)
            }
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
