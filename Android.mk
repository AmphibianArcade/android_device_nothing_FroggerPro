LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),FroggerPro)

# avbtool reads pvmfw's descriptor (BoardConfig.mk), but the build's
# vbmeta_system rule does not list it as an input, so a re-extracted
# pvmfw.img would leave a stale descriptor behind.
$(PRODUCT_OUT)/vbmeta_system.img: $(FROGGERPRO_PVMFW_IMAGE)

endif
