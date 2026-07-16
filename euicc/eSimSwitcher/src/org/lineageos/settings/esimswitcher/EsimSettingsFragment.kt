/*
 * SPDX-FileCopyrightText: 2026 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

package org.lineageos.settings.esimswitcher

import android.os.Bundle
import androidx.appcompat.app.AlertDialog
import androidx.preference.Preference
import androidx.preference.SwitchPreferenceCompat
import com.android.settingslib.widget.SettingsBasePreferenceFragment

class EsimSettingsFragment :
    SettingsBasePreferenceFragment(), Preference.OnPreferenceChangeListener {
    private lateinit var controller: EsimController

    override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
        setPreferencesFromResource(R.xml.esim_settings, rootKey)
        controller = EsimController.getInstance(requireContext())

        val switcher = findPreference<SwitchPreferenceCompat>(ESIM_TOGGLE_KEY)
        switcher?.isChecked = controller.getEsimEnabled() == true
        switcher?.onPreferenceChangeListener = this
    }

    override fun onPreferenceChange(preference: Preference, newValue: Any?): Boolean {
        val enable = newValue as Boolean
        EsimController.getInstance(requireContext()).ensureBound { success ->
            if (success) {
                if (enable) {
                    AlertDialog.Builder(requireContext())
                        .setMessage(R.string.esim_toggle_dialog)
                        .setNegativeButton(R.string.esim_toggle_dialog_cancel) { dialog, _ ->
                            dialog.dismiss()
                        }
                        .setPositiveButton(R.string.esim_toggle_dialog_ok) { dialog, _ ->
                            dialog.dismiss()
                            controller.setEsimEnabled(enable)
                            (preference as? SwitchPreferenceCompat)?.isChecked = true
                        }
                        .show()
                } else {
                    controller.setEsimEnabled(enable)
                    (preference as? SwitchPreferenceCompat)?.isChecked = false
                }
            }
        } 
        return false
    }

    companion object {
        private const val ESIM_TOGGLE_KEY = "esim_toggle"
    }
}
