#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, hardware/qcom-caf/common/common.mk)
$(call inherit-product, vendor/nothing/froggerpro/froggerpro-vendor.mk)

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

PRODUCT_VENDOR_PROPERTIES += \
    ro.virtual_ab.compression.threads=true \
    ro.virtual_ab.merge_delay_seconds=180

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

PRODUCT_VENDOR_PROPERTIES += \
    graphics.gpu.profiler.support=true \
    ro.gfx.driver.1=com.qualcomm.qti.gpudrivers.sun.api35 \
    ro.hardware.egl=adreno \
    ro.hardware.vulkan=adreno \
    ro.opengles.version=196610

# Audio
$(call soong_config_set_bool, qtiaudio, aw882xx_smartpa, true)

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/conf/audio/mixer_paths_kera_froggerpro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/mixer_paths_kera_froggerpro.xml \
    $(LOCAL_PATH)/conf/audio/resourcemanager_kera_froggerpro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/resourcemanager_kera_froggerpro.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/stub_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/stub_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    hardware/qcom-caf/sm8750/audio/pal/configs/sun/card-defs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/card-defs.xml \
    hardware/qcom-caf/sm8750/audio/pal/configs/sun/usecaseKvManager.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usecaseKvManager.xml \
    hardware/qcom-caf/sm8750/audio/primary-hal/configs/common/bluetooth_qti_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_qti_audio_policy_configuration.xml \
    hardware/qcom-caf/sm8750/audio/primary-hal/configs/common/bluetooth_qti_hearing_aid_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_qti_hearing_aid_audio_policy_configuration.xml \
    hardware/qcom-caf/sm8750/audio/primary-hal/configs/sun/audio_effects_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/audio_effects_config.xml \
    hardware/qcom-caf/sm8750/audio/primary-hal/configs/sun/audio_module_config_primary.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/audio_module_config_primary.xml \
    hardware/qcom-caf/sm8750/audio/primary-hal/configs/sun/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/audio_policy_configuration.xml \
    hardware/qcom-caf/sm8750/audio/primary-hal/configs/sun/vendor_audio_interfaces.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/sku_kera/vendor_audio_interfaces.xml

PRODUCT_PACKAGES += \
    audioadsprpcd \
    audiohalservice.qti \
    aw882xx_cali \
    lib_bt_aptx \
    lib_bt_ble \
    lib_bt_bundle \
    libagm_compress_plugin \
    libagm_mixer_plugin \
    libagm_pcm_plugin \
    libagmipcservice \
    libaudiochargerlistener \
    libaudiocorehal.default \
    libaudiocorehal.qti \
    libaudioeffecthal.qti \
    libbatterylistener \
    libbundleaidl \
    libcustomva_intf \
    libdownmixaidl \
    libdynamicsprocessingaidl \
    libfmpal \
    libhfp_pal \
    libhotword_intf \
    libloudnessenhanceraidl \
    libmodulebluetoothdefault.qti \
    libpalclient \
    libpaleventnotifier \
    libpalipcservice \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libreverbaidl \
    libsoundtriggerhal.qti \
    libvisualizeraidl \
    libvolumelistener \
    qtiaudiohalvendorextn

PRODUCT_PRODUCT_PROPERTIES += \
    aaudio.hw_burst_min_usec=2000 \
    aaudio.mmap_exclusive_policy=2 \
    aaudio.mmap_policy=2 \
    af.fast_track_multiplier=1 \
    audio.deep_buffer.media=true \
    audio.offload.min.duration.secs=30 \
    audio.offload.video=true \
    audio.sys.mute.latency.factor=2 \
    audio.sys.noisy.broadcast.delay=500 \
    audio.sys.offload.pstimeout.secs=3 \
    audio.sys.routing.latency=0 \
    audio.timecheck.timeout_duration_ms=8000 \
    ro.af.client_heap_size_kbyte=7168 \
    ro.audio.monitorRotation=true

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.audio.ihaladaptervendorextension_enabled=true

PRODUCT_VENDOR_PROPERTIES += \
    aaudio.hw_burst_min_usec=2000 \
    aaudio.mmap_exclusive_policy=2 \
    aaudio.mmap_policy=2 \
    audio.spatializer.pose_predictor_type=1 \
    ro.audio.flinger_standbytime_ms=2000 \
    ro.audio.spatializer_enabled=true \
    ro.audio.stereo_spatialization_enabled=true \
    vendor.audio.adm.buffering.ms=2 \
    vendor.audio.c2.preferred=true \
    vendor.audio.compress_capture.aac=false \
    vendor.audio.compress_capture.enabled=false \
    vendor.audio.feature.a2dp_offload.enable=true \
    vendor.audio.feature.battery_listener.enable=true \
    vendor.audio.feature.dmabuf.cma.memory.enable=false \
    vendor.audio.feature.hfp.enable=true \
    vendor.audio.feature.kpi_optimize.enable=true \
    vendor.audio.flac.sw.decoder.24bit=true \
    vendor.audio.hal.aidl.enabled=true \
    vendor.audio.hal.output.suspend.supported=true \
    vendor.audio.hdr.record.enable=false \
    vendor.audio.hdr.spf.record.enable=false \
    vendor.audio.hw.aac.encoder=false \
    vendor.audio.offload.buffer.size.kb=32 \
    vendor.audio.offload.multiple.enabled=false \
    vendor.audio.offload.track.enable=true \
    vendor.audio.ull_record_period_multiplier=2 \
    vendor.audio.use.sw.alac.decoder=true \
    vendor.audio.use.sw.ape.decoder=true \
    vendor.audio.use.sw.mpegh.decoder=true \
    vendor.audio.volume.headset.gain.depcal=true \
    vendor.audio_hal.period_size=192 \
    vendor.audio_hal.timecheck_timeoutMS=8000 \
    vendor.qc2audio.per_frame.flac.dec.enabled=true
    vendor.qc2audio.suspend.enabled=true

# Bluetooth
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml

PRODUCT_PRODUCT_PROPERTIES += \
    bluetooth.device_id.vendor_id=0x001D \
    bluetooth.profile.a2dp.source.enabled=true \
    bluetooth.profile.avrcp.controller.enabled=true \
    bluetooth.profile.avrcp.target.enabled=true \
    bluetooth.profile.bas.client.enabled=true \
    bluetooth.profile.gatt.enabled=true \
    bluetooth.profile.hfp.ag.enabled=true \
    bluetooth.profile.hid.device.enabled=true \
    bluetooth.profile.hid.host.enabled=true \
    bluetooth.profile.map.server.enabled=true \
    bluetooth.profile.opp.enabled=true \
    bluetooth.profile.pbap.server.enabled=true

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    bluetooth.core.le.max_number_of_concurrent_connections=10 \
    bluetooth.device.class_of_device=90,2,12 \
    bluetooth.hfp.codec_aptx_voice.enabled=true \
    bluetooth.hfp.swb.aptx.power_management.enabled=true \
    bluetooth.leaudio.dual_bidirection_swb.supported=true \
    bluetooth.profile.pan.nap.enabled=true \
    bluetooth.profile.pan.panu.enabled=true \
    bluetooth.profile.pbap.sim.enabled=true \
    bluetooth.profile.sap.server.enabled=true \
    persist.bluetooth.leaudio.bypass_allow_list=false \
    persist.bluetooth.leaudio.notify.idle.during.call=true \
    persist.bluetooth.leaudio_offload.disabled=false \
    persist.vendor.bluetooth.haltest=true \
    ro.bluetooth.leaudio_offload.supported=true

PRODUCT_VENDOR_PROPERTIES += \
    bluetooth.profile.asha.central.enabled=true \
    bluetooth.profile.bap.broadcast.assist.enabled=true \
    bluetooth.profile.bap.broadcast.source.enabled=true \
    bluetooth.profile.bap.unicast.client.enabled=true \
    bluetooth.profile.ccp.server.enabled=true \
    bluetooth.profile.csip.set_coordinator.enabled=true \
    bluetooth.profile.hap.client.enabled=true \
    bluetooth.profile.mcp.server.enabled=true \
    bluetooth.profile.vcp.controller.enabled=true \
    persist.bluetooth.a2dp_offload.cap=sbc-aac-aptx-aptxhd-ldac \
    persist.bluetooth.a2dp_offload.disabled=false \
    persist.bluetooth.leaudio_offload.disabled=false \
    persist.sys.fflag.override.settings_bluetooth_hearing_aid=true \
    persist.vendor.bluetooth.modem_nv_support=true \
    persist.vendor.bt.a2dp_offload_cap=sbc-aptx-aptxtws-aptxhd-aac-ldac \
    persist.vendor.bt.aac_frm_ctl.enabled=true \
    persist.vendor.bt.aac_vbr_frm_ctl.enabled=true \
    persist.vendor.qcom.bluetooth.aac_vbr_ctl.enabled=true \
    persist.vendor.qcom.bluetooth.aptxadaptiver2_1_support=true \
    persist.vendor.qcom.bluetooth.dualmode_transport_support=true \
    persist.vendor.qcom.bluetooth.fmd_config_info=80:0C:60:90:0F:00:00:14:01 \
    persist.vendor.qcom.bluetooth.fmd_header=8:02:01:06:18:16:AA:FE:40 \
    persist.vendor.qcom.bluetooth.lossless_aptx_adaptive_le.enabled=true \
    ro.bluetooth.a2dp_offload.supported=true \
    ro.vendor.bluetooth.btconfigstore=false

# Biometrics
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

PRODUCT_PRODUCT_PROPERTIES += \
    masterclear.allow_retain_esim_profiles_after_fdr=true

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

PRODUCT_PRODUCT_PROPERTIES += \
    ro.camerax.extensions.enabled=true

# DPM
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.vendor.dpm.feature=11

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.dpm.vndr.feature=11

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey

PRODUCT_VENDOR_PROPERTIES += \
    drm.service.enabled=true

# Dalvik
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# Data
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.data.mutualex.mode=wifipreferred \
    persist.vendor.data.qms.stx_disable=true

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

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.view.vrr.velocity_threshold=120@0 \
    sys.brightness.disable_gamma_conversion=true

PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.display.set_doze_fps_modeid=4 \
    vendor.display.comp_mask=0 \
    vendor.display.disable_3d_adaptive_tm=1 \
    vendor.display.disable_cwb_idle_fallback=1 \
    vendor.display.disable_dynamic_fps=1 \
    vendor.display.disable_excl_rect=0 \
    vendor.display.disable_excl_rect_partial_fb=1 \
    vendor.display.disable_hw_recovery_dump=1 \
    vendor.display.disable_offline_rotator=1 \
    vendor.display.disable_scaler=0 \
    vendor.display.disable_sdr_dimming=0 \
    vendor.display.disable_sdr_histogram=1 \
    vendor.display.disable_stc_dimming=1 \
    vendor.display.enable_async_powermode=0 \
    vendor.display.enable_async_vds_creation=1 \
    vendor.display.enable_display_extensions=1 \
    vendor.display.enable_dpps_dynamic_fps=1 \
    vendor.display.enable_early_wakeup=1 \
    vendor.display.enable_fp_unlock_Optimization=1 \
    vendor.display.enable_hdr10_gpu_target=1 \
    vendor.display.enable_ic_hw_roundedcorner=1 \
    vendor.display.enable_optimize_refresh=0 \
    vendor.display.enable_rc_support=1 \
    vendor.display.enable_rounded_corner=1 \
    vendor.display.use_layer_ext=1 \
    vendor.display.use_smooth_motion=1 \
    vendor.display.vds_allow_hwc=1 \
    vendor.gralloc.disable_ubwc=0 \
    vendor.gralloc.enable_logs=0 \
    vendor.gralloc.enable_snapalloc=1

# eUICC
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_EEA/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_JPN/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_ROW/android.hardware.telephony.euicc.xml \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_ODM)/etc/permissions/sku_TUR/android.hardware.telephony.euicc.xml

# FRP
PRODUCT_VENDOR_PROPERTIES += \
    ro.frp.pst=/dev/block/bootdevice/by-name/frp

# FUSE
PRODUCT_VENDOR_PROPERTIES += \
    persist.sys.fuse.passthrough.enable=true

# Fastboot
PRODUCT_PACKAGES += \
    fastbootd

# GPS
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

# Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-V1-ndk.vendor

PRODUCT_VENDOR_PROPERTIES += \
    debug.egl.hw=0 \
    debug.graphics.game_default_frame_rate.disabled=0 \
    debug.hwui.8bit_hdr_headroom=8 \
    debug.sf.auto_latch_unsignaled=1 \
    debug.sf.disable_client_composition_cache=1 \
    debug.sf.early.app.duration=13666666 \
    debug.sf.early.sf.duration=10500000 \
    debug.sf.earlyGl.app.duration=13666666 \
    debug.sf.earlyGl.sf.duration=10500000 \
    debug.sf.enable_advanced_sf_phase_offset=1 \
    debug.sf.enable_gl_backpressure=1 \
    debug.sf.hw=0 \
    debug.sf.latch_unsignaled=0 \
    debug.sf.late.app.duration=13666666 \
    debug.sf.late.sf.duration=10500000 \
    debug.sf.predict_hwc_composition_strategy=0 \
    debug.sf.region_sampling_period_ns=300000000 \
    debug.sf.region_sampling_timer_timeout_ns=300000000 \
    debug.sf.treat_170m_as_sRGB=1 \
    debug.sf.use_phase_offsets_as_durations=1 \
    persist.sys.sf.color_mode=0 \
    persist.sys.sf.color_saturation=1.0 \
    persist.sys.sf.native_mode=260 \
    ro.surface_flinger.clear_slots_with_set_layer_buffer=false \
    ro.surface_flinger.force_hwc_copy_for_virtual_displays=true \
    ro.surface_flinger.game_default_frame_rate_override=60 \
    ro.surface_flinger.has_HDR_display=true \
    ro.surface_flinger.has_wide_color_display=true \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=3 \
    ro.surface_flinger.max_virtual_display_dimension=4096 \
    ro.surface_flinger.protected_contents=true \
    ro.surface_flinger.set_idle_timer_ms=550 \
    ro.surface_flinger.set_touch_timer_ms=200 \
    ro.surface_flinger.use_color_management=true \
    ro.surface_flinger.use_content_detection_for_refresh_rate=true \
    ro.surface_flinger.wcg_composition_dataspace=143261696

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

# Incremental FS
PRODUCT_VENDOR_PROPERTIES += \
    ro.incremental.enable=yes

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

PRODUCT_VENDOR_PROPERTIES += \
    ro.crypto.metadata_init_delete_all_keys.enabled=true \
    ro.hardware.keystore_desede=true \
    vendor.gatekeeper.is_security_level_spu=0 \
    vendor.keymint.retry_timer=5 \
    vendor.spu.rkp_enabled=true

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-service.lineage

# Media
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_c2_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_c2_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml

PRODUCT_PRODUCT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true \
    media.stagefright.audio.deep=false

PRODUCT_VENDOR_PROPERTIES += \
    debug.c2.use_dmabufheaps=1 \
    debug.stagefright.c2inputsurface=-1 \
    debug.stagefright.ccodec=4 \
    debug.stagefright.omx_default_rank=0 \
    media.c2.hal.selection=aidl \
    ro.mediaserver.64b.enable=true

# NFC
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml

PRODUCT_PACKAGES += \
    android.hardware.nfc-service.st

# OEM Unlock
PRODUCT_VENDOR_PROPERTIES += \
    ro.oem_unlock_supported=1

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

# PASR
PRODUCT_VENDOR_PROPERTIES += \
    vendor.pasr.activemode.enabled=false \
    vendor.power.pasr.enabled=false

# Page Size
PRODUCT_CHECK_PREBUILT_MAX_PAGE_SIZE := false

# Partitions
PRODUCT_BUILD_RECOVERY_IMAGE := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true

PRODUCT_PACKAGES += \
    vendor_bt_firmware_mountpoint \
    vendor_dsp_mountpoint \
    vendor_firmware_mnt_mountpoint

# Performance
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.extension_library=libqti-perfd-client.so \
    ro.vendor.perf-hal.ver=3.0 \
    ro.vendor.perf.scroll_opt=1 \
    vendor.perf.framepacing.enable=1

# Power
PRODUCT_PACKAGES += \
    android.hardware.power-service-qti

# Properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.product.property_source_order=odm,vendor,product,system_ext,system

# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# QSPA
PRODUCT_PACKAGES += \
    qspa_vendor.rc \
    vendor.qti.qspa-service

# QSPM
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.qspm.enable=true

# QTI VND FWK
PRODUCT_ODM_PROPERTIES += \
    ro.vendor.qti.va_odm.support=1

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.vendor.qti.va_aosp.support=1

# RCS
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.rcs.singlereg.feature=1

# RIL
PRODUCT_VENDOR_PROPERTIES += \
    persist.radio.multisim.config=dsds \
    persist.vendor.radio.apm_sim_not_pwdn=1 \
    persist.vendor.radio.custom_ecc=1 \
    persist.vendor.radio.enableadvancedscan=true \
    persist.vendor.radio.procedure_bytes=SKIP \
    persist.vendor.radio.sib16_support=1

# Ramdisk
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)

# SoC
PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=QTI

# SSR
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.ssr.restart_level=ALL_ENABLE

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
    sensors.dynamic_sensor_hal

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.sensors.debug.hal=e

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

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.telephony.sim_slots.count=3 \
    telephony.active_modems.max_count=2

PRODUCT_VENDOR_PROPERTIES += \
    ro.telephony.default_network=26,26

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

PRODUCT_VENDOR_PROPERTIES += \
    sys.usb.mtp.batchcancel=1 \
    sys.vendor.shutdown.waittime=500 \
    vendor.usb.controller=a600000.dwc3 \
    vendor.usb.diag.func.name=ffs \
    vendor.usb.dpl.inst.name=dpl \
    vendor.usb.qdss.inst.name=qdss_sw \
    vendor.usb.rmnet.func.name=gsi \
    vendor.usb.rmnet.inst.name=rmnet \
    vendor.usb.rndis.func.name=gsi \
    vendor.usb.use_ffs_mtp=1 \
    vendor.usb.use_gadget_hal=1

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

PRODUCT_VENDOR_PROPERTIES += \
    wifi.aware.interface=wifi-aware0

# Widevine
PRODUCT_VENDOR_PROPERTIES += \
    vendor.wv.oemcrypto.debug.enable_external_display_check=false \
    vendor.wv.oemcrypto.debug.enable_hlos_data_path=true \
    vendor.wv.oemcrypto.debug.enable_prov40=true
