#
# Copyright (C) 2009 The Android-x86 Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#

ifeq ($(TARGET_PREBUILT_KERNEL),)

ifeq ($(TARGET_ARCH),x86)
KERNEL_TARGET := bzImage
TARGET_KERNEL_CONFIG ?= android-x86_defconfig
endif
ifeq ($(TARGET_ARCH),arm)
KERNEL_TARGET := zImage
TARGET_KERNEL_CONFIG ?= goldfish_defconfig
endif

KBUILD_OUTPUT := $(CURDIR)/$(TARGET_OUT_INTERMEDIATES)/kernel
mk_kernel := + $(hide) $(MAKE) -C kernel O=$(KBUILD_OUTPUT) ARCH=$(TARGET_ARCH) $(if $(SHOW_COMMANDS),V=1)
ifneq ($(TARGET_ARCH),$(HOST_ARCH))
mk_kernel += CROSS_COMPILE=$(CURDIR)/$(TARGET_TOOLS_PREFIX)
endif

ifneq ($(wildcard $(TARGET_KERNEL_CONFIG)),)
KERNEL_CONFIG_FILE := $(TARGET_KERNEL_CONFIG)
else
KERNEL_CONFIG_FILE := kernel/arch/$(TARGET_ARCH)/configs/$(TARGET_KERNEL_CONFIG)
endif
MOD_ENABLED := $(shell grep ^CONFIG_MODULES=y $(KERNEL_CONFIG_FILE))
FIRMWARE_ENABLED := $(shell grep ^CONFIG_FIRMWARE_IN_KERNEL=y $(KERNEL_CONFIG_FILE))

# I understand Android build system discourage to use submake,
# but I don't want to write a complex Android.mk to build kernel.
# This is the simplest way I can think.
KERNEL_DOTCONFIG_FILE := $(KBUILD_OUTPUT)/.config
$(KERNEL_DOTCONFIG_FILE): $(KERNEL_CONFIG_FILE) | $(ACP)
	$(copy-file-to-new-target)

BUILT_KERNEL_TARGET := $(KBUILD_OUTPUT)/arch/$(TARGET_ARCH)/boot/$(KERNEL_TARGET)
$(INSTALLED_KERNEL_TARGET): $(KERNEL_DOTCONFIG_FILE)
	$(mk_kernel) oldnoconfig
	$(mk_kernel) $(KERNEL_TARGET) $(if $(MOD_ENABLED),modules)
	$(hide) $(ACP) -fp $(BUILT_KERNEL_TARGET) $@
ifdef TARGET_PREBUILT_MODULES
	$(hide) $(ACP) -r $(TARGET_PREBUILT_MODULES) $(TARGET_OUT)/lib
else
	$(hide) rm -rf $(TARGET_OUT)/lib/modules
	$(if $(MOD_ENABLED),$(mk_kernel) INSTALL_MOD_PATH=$(CURDIR)/$(TARGET_OUT) modules_install)
	$(hide) rm -f $(TARGET_OUT)/lib/modules/*/{build,source}
endif
	$(if $(FIRMWARE_ENABLED),$(mk_kernel) INSTALL_MOD_PATH=$(CURDIR)/$(TARGET_OUT) firmware_install)

# rules to get source of Broadcom 802.11a/b/g/n hybrid device driver
# based on broadcomsetup.sh of Kyle Evans
WL_ENABLED := $(shell grep ^CONFIG_WL=[my] $(KERNEL_CONFIG_FILE))
WL_PATH := drivers/net/wireless/wl
WL_SRC := kernel/$(WL_PATH)/hybrid-portsrc_x86_32-v5_100_82_38.tar.gz
$(WL_SRC):
	@echo Downloading $(@F)...
	$(hide) curl http://www.broadcom.com/docs/linux_sta/$(@F) > $@ && tar zxf $@ -C $(@D) --overwrite && (cd kernel; git checkout $(WL_PATH)) && \
		sed -i '/<linux\/wireless.h>/ a#include <linux/semaphore.h>' $(@D)/src/wl/sys/wl_iw.h && \
		sed -i 's/init_MUTEX(&wl->sem)/\n#ifndef init_MUTEX\nsema_init(\&wl->sem,1)\n#else\ninit_MUTEX(\&wl->sem)\n#endif\n/' $(@D)/src/wl/sys/wl_linux.c
$(INSTALLED_KERNEL_TARGET): $(if $(WL_ENABLED),$(WL_SRC))

installclean: FILES += $(KBUILD_OUTPUT) $(INSTALLED_KERNEL_TARGET)

TARGET_PREBUILT_KERNEL  := $(INSTALLED_KERNEL_TARGET)

.PHONY: kernel
kernel: $(TARGET_PREBUILT_KERNEL)

else

$(INSTALLED_KERNEL_TARGET): $(TARGET_PREBUILT_KERNEL) | $(ACP)
	$(copy-file-to-new-target)

endif # TARGET_PREBUILT_KERNEL
