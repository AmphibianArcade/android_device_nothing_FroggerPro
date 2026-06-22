#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, hardware/qcom-caf/common/common.mk)
$(call inherit-product, vendor/nothing/FroggerPro/FroggerPro-vendor.mk)

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/vabc_features.mk)

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

PRODUCT_VIRTUAL_AB_COMPRESSION_METHOD := lz4

# API
PRODUCT_SHIPPING_API_LEVEL := 36

# ART
PRODUCT_ENABLE_UFFD_GC := true

# Adreno
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_3.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml

# Audio
PRODUCT_PACKAGES += \
    audio.bluetooth.default \
    audio.r_submix.default \
    audio.usbv2.default \
    libhapticgenerator \
    qtiaudiohalvendorextn \
    qti-audio-types-aidl-V1-ndk.vendor

PRODUCT_PACKAGES += \
    android.hardware.soundtrigger3-V1-ndk.vendor \
    android.hardware.audio.effect-V2-ndk.vendor \
    android.media.audio.common.types-V3-ndk.vendor \
    android.hardware.audio.common-V1-ndk.vendor \
    android.hardware.audio.core-V2-ndk.vendor \
    android.hardware.audio.core.sounddose-V3-ndk.vendor \
    android.hardware.audio.core.sounddose-V1-ndk.vendor \
    libalsautilsv2.vendor \
    libaudioaidlcommon.vendor \
    libaudioutils_shim \
    libmediautils_vendor.vendor \
    libmemunreachable.vendor

AUDIO_HAL_DIR := hardware/qcom-caf/sm8750/audio/primary-hal
CONFIG_HAL_SRC_DIR := $(AUDIO_HAL_DIR)/configs/sun
CONFIG_PAL_SRC_DIR := $(AUDIO_HAL_DIR)/../pal/configs/sun

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/conf/audio/audio_module_config_primary.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/audio_module_config_primary.xml \
    $(LOCAL_PATH)/conf/audio/mixer_paths_kera_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/mixer_paths_kera_qrd.xml \
    $(LOCAL_PATH)/conf/audio/resourcemanager_kera_qrd.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/resourcemanager_kera_qrd.xml \
    $(LOCAL_PATH)/conf/audio/quasar_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/quasar_config.xml \
    $(LOCAL_PATH)/conf/audio/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/default_volume_tables.xml \
    $(LOCAL_PATH)/conf/audio/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    $(LOCAL_PATH)/conf/audio/usecaseKvManager.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usecaseKvManager.xml \
    $(LOCAL_PATH)/conf/audio/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/audio_policy_volumes.xml \
    $(LOCAL_PATH)/conf/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/audio_policy_configuration.xml \
    $(LOCAL_PATH)/conf/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(LOCAL_PATH)/conf/audio/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/audio_effects.conf \
    $(LOCAL_PATH)/conf/audio/backend_conf.xml:$(TARGET_COPY_OUT_VENDOR)/etc/backend_conf.xml

PRODUCT_COPY_FILES += \
    $(CONFIG_HAL_SRC_DIR)/audio_effects_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/audio_effects_config.xml \
    $(CONFIG_HAL_SRC_DIR)/mem_logger_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mem_logger_config.xml \
    $(CONFIG_HAL_SRC_DIR)/microphone_characteristics.xml:$(TARGET_COPY_OUT_VENDOR)/etc/microphone_characteristics.xml \
    $(CONFIG_HAL_SRC_DIR)/vendor_audio_interfaces.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/vendor_audio_interfaces.xml \
    $(CONFIG_PAL_SRC_DIR)/Hapticsconfig.xml:$(TARGET_COPY_OUT_VENDOR)/etc/Hapticsconfig.xml \
    $(CONFIG_PAL_SRC_DIR)/card-defs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/card-defs.xml

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/stub_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/stub_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml
    
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio-impl \
    android.hardware.bluetooth.audio-V4-ndk.vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml

# Biometrics
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

# Boot Control
PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery

# Camera
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.concurrent.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.concurrent.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

PRODUCT_PACKAGES += \
    vendor.qti.hardware.display.config-V2-ndk.vendor

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey

# Dalvik
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# Display
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/conf/display/display_id_4630947050240568210.xml:$(TARGET_COPY_OUT_VENDOR)/etc/displayconfig/display_id_4630947050240568210.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    hardware/qcom-caf/sm8750/display/core/config/sdm_display_resolution_extn.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display/sdm_display_resolution_extn.xml \
    hardware/qcom-caf/sm8750/display/core/snapalloc/resources/camera_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/camera_alignments.json \
    hardware/qcom-caf/sm8750/display/core/snapalloc/resources/cpu_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/cpu_alignments.json \
    hardware/qcom-caf/sm8750/display/core/snapalloc/resources/default_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/default_alignments.json \
    hardware/qcom-caf/sm8750/display/core/snapalloc/resources/display_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/display_alignments.json \
    hardware/qcom-caf/sm8750/display/core/snapalloc/resources/formats.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/formats.json \
    hardware/qcom-caf/sm8750/display/core/snapalloc/resources/graphics_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/graphics_alignments.json \
    hardware/qcom-caf/sm8750/display/core/snapalloc/resources/ubwc_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/ubwc_alignments.json \
    hardware/qcom-caf/sm8750/display/core/snapalloc/resources/video_alignments.json:$(TARGET_COPY_OUT_VENDOR)/etc/display/video_alignments.json

PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@4.0-impl-qti-display \
    init.qti.display_boot.rc \
    init.qti.display_boot.sh \
    libqdMetaData \
    vendor.qti.hardware.display.allocator-service \
    vendor.qti.hardware.display.composer-service \
    vendor.qti.hardware.display.demura-service \
    vendor.qti.hardware.display.snapalloc-impl \
    vendor.qti.hardware.memtrack-service

# eUICC
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_EEA/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_JPN/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_ROW/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_TUR/android.hardware.telephony.euicc.xml

# Fastboot
PRODUCT_PACKAGES += \
    fastbootd

# GPS
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

# Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-V1-ndk.vendor

# HIDL
PRODUCT_HIDL_ENABLED := true

PRODUCT_PACKAGES += \
    android.hidl.allocator@1.0-service \
    android.hidl.memory@1.0-impl \
    hwservicemanager

# Handheld
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.qti \
    android.hardware.health-service.qti_recovery

# IPA
PRODUCT_PACKAGES += \
    IPACM_Filter_cfg.xml \
    IPACM_cfg.xml \
    ipacm

# Init
PRODUCT_PACKAGES += \
    fstab.default \
    fstab.default.vendor_ramdisk \
    init.class_main.sh \
    init.froggerpro.rc \
    init.qcom.early_boot.sh \
    init.qcom.post_boot.sh \
    init.qcom.rc \
    init.qcom.recovery.rc \
    init.qcom.sh \
    init.target.rc \
    ueventd.froggerpro.rc \
    ueventd.qcom.rc

# Keymint
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml

PRODUCT_PACKAGES += \
    android.hardware.hardware_keystore_V3.xml

# Media
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml

# NFC
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml

PRODUCT_PACKAGES += \
    android.hardware.nfc-service.st

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

PRODUCT_PACKAGES += \
    FroggerProApertureDevOverlay \
    FroggerProApertureOverlay \
    FroggerProFrameworksOverlay \
    FroggerProSettingsOverlay \
    FroggerProSettingsProviderOverlay \
    FroggerProSystemUIOverlay \
    FroggerProTelecommOverlay \
    FroggerProTelephonyOverlay \
    FroggerProWifiOverlay

# Page Size
PRODUCT_CHECK_PREBUILT_MAX_PAGE_SIZE := false

# Partitions
PRODUCT_BUILD_RECOVERY_IMAGE := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true

PRODUCT_PACKAGES += \
    vendor_bt_firmware_mountpoint \
    vendor_dsp_mountpoint \
    vendor_firmware_mnt_mountpoint

# Power
PRODUCT_PACKAGES += \
    android.hardware.power-service-qti

# Properties
TARGET_ODM_PROP += $(DEVICE_PATH)/odm.prop
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/product.prop
TARGET_SYSTEM_EXT_PROP += $(DEVICE_PATH)/system_ext.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# QSPA
PRODUCT_PACKAGES += \
    qspa_vendor.rc \
    vendor.qti.qspa-service

# Ramdisk
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# Security
BOOT_SECURITY_PATCH := 2026-04-05
INIT_BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
ODM_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
SYSTEM_DLKM_SECURITY_PATCH := $(BOOT_SECURITY_PATCH)
VENDOR_DLKM_SECURITY_PATCH := 2026-03-05
VENDOR_SECURITY_PATCH := 2026-05-01

# Sensors
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_kera/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_kera/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_kera/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_kera/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_kera/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_kera/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_kera/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/sku_kera/android.hardware.sensor.gyroscope.xml

PRODUCT_PACKAGES += \
    android.hardware.sensors-service.multihal \
    sensors.froggerpro \
    sensors.dynamic_sensor_hal

# SKUs
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/sku/build_EEA.prop:$(TARGET_COPY_OUT_ODM)/etc/build_EEA.prop \
    $(LOCAL_PATH)/sku/build_IND.prop:$(TARGET_COPY_OUT_ODM)/etc/build_IND.prop \
    $(LOCAL_PATH)/sku/build_JPN.prop:$(TARGET_COPY_OUT_ODM)/etc/build_JPN.prop \
    $(LOCAL_PATH)/sku/build_TUR.prop:$(TARGET_COPY_OUT_ODM)/etc/build_TUR.prop

# Soong
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Storage
PRODUCT_CHARACTERISTICS := nosdcard

# Telephony
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.telephony.mbms.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.mbms.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml

PRODUCT_PACKAGES += \
    ims-ext-common \
    ims_ext_common.xml \
    qti-telephony-hidl-wrapper \
    qti-telephony-hidl-wrapper-prd \
    qti-telephony-utils \
    qti_telephony_hidl_wrapper.xml \
    qti_telephony_hidl_wrapper_prd.xml \
    qti_telephony_utils.xml

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.qti

# USB
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

PRODUCT_PACKAGES += \
    android.hardware.usb.gadget-service.qti \
    android.hardware.usb-service.qti \
    init.qcom.usb.rc \
    init.qcom.usb.sh

PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/usb/etc

# Update Engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

# Vendor Service Manager
PRODUCT_PACKAGES += \
    vndservicemanager

# Verified Boot
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator.service.froggerpro-richtap

# Wi-Fi
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml

PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    firmware_wlanmdsp.otaupdate_symlink \
    firmware_wlan_mac.bin_symlink \
    hostapd \
    libwifi-hal-ctrl \
    libwifi-hal-qcom \
    wpa_supplicant \
    wpa_supplicant.conf

