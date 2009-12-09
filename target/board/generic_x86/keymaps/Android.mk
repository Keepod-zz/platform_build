#
# Copyright (C) 2009 The Android-x86 Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#

define include-keymap

include $$(CLEAR_VARS)
LOCAL_SRC_FILES := $(1)
include $$(BUILD_KEY_CHAR_MAP)

$$(call add-prebuilt-target,$$(TARGET_OUT_KEYLAYOUT),$$(subst .kcm,.kl,$(1)))

endef

define add-keymap
$(eval $(include-keymap))
endef

define add-keymaps
$(foreach f,$(1),$(call add-keymap,$(f)))
endef

LOCAL_KEYMAPS_DIR ?= $(call my-dir)
LOCAL_PATH := $(LOCAL_KEYMAPS_DIR)
LOCAL_KEYMAPS ?= $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/*.kcm))
$(call add-keymaps,$(LOCAL_KEYMAPS))
