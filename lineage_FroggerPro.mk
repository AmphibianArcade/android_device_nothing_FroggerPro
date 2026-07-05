#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_product.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_product.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_system_ext.mk)

$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_vendor.mk)

$(call inherit-product, device/nothing/FroggerPro/device.mk)
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_BRAND := Nothing
PRODUCT_DEVICE := FroggerPro
PRODUCT_MANUFACTURER := Nothing
PRODUCT_MODEL := A069P
PRODUCT_NAME := lineage_FroggerPro

PRODUCT_GMS_CLIENTID_BASE := android-nothing

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="qssi_64-user 16 BQ2A.250913.001-BP2A.250605.031.A3 2603231635 release-keys" \
    BuildFingerprint=Nothing/FroggerPro/FroggerPro:16/BQ2A.250913.001-BP2A.250605.031.A3/2603231635:user/release-keys \
    DeviceName=FroggerPro \
    DeviceProduct=FroggerPro \
    SystemDevice=FroggerPro \
    SystemName=FroggerPro
