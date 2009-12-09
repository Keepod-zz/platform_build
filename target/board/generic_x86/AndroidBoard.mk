LOCAL_PATH := $(call my-dir)
$(call add-prebuilt-target,$(TARGET_ROOT_OUT),init.rc)

include $(call all-subdir-makefiles)
