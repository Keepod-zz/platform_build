LOCAL_PATH := $(call my-dir)
DEFAULT_WPA_SUPPLICANT_CONF_DIR := $(LOCAL_PATH)

$(call add-prebuilt-target,$(TARGET_ROOT_OUT),init.rc)

include $(call all-subdir-makefiles)

define include-wpa-supplicant-conf
LOCAL_PATH := $(1)
include $$(CLEAR_VARS)
LOCAL_MODULE := wpa_supplicant.conf
LOCAL_MODULE_TAGS := user
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $$(TARGET_OUT_ETC)/wifi
LOCAL_SRC_FILES := $$(LOCAL_MODULE)
LOCAL_PREBUILT_STRIP_COMMENTS := 1
include $$(BUILD_PREBUILT)
endef

define add-wpa-supplicant-conf
$(eval $(include-wpa-supplicant-conf))
endef

ifneq ($(BOARD_WPA_SUPPLICANT_DRIVER),)
BOARD_WPA_SUPPLICANT_CONF_DIR ?= $(DEFAULT_WPA_SUPPLICANT_CONF_DIR)
$(call add-wpa-supplicant-conf,$(BOARD_WPA_SUPPLICANT_CONF_DIR))
endif
