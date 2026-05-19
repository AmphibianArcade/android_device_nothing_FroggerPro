#
# SPDX-FileCopyrightText: 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/nothing/FroggerPro

$(call inherit-product, hardware/qcom-caf/common/common.mk)

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := kryo300
TARGET_CPU_VARIANT_RUNTIME := oryon

# Audio
$(call soong_config_set, android_hardware_audio, run_64bit, true)
PRODUCT_PACKAGES += \
    android.hardware.audio.service

AUDIO_HAL_DIR := hardware/qcom-caf/sm8750/audio/primary-hal
AUDIO_PAL_DIR := hardware/qcom-caf/sm8750/audio/pal
