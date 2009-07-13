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
$(KBUILD_OUTPUT):
	mkdir -p $(KBUILD_OUTPUT)

mk_kernel := + $(hide) $(MAKE) -C kernel O=$(KBUILD_OUTPUT) ARCH=$(TARGET_ARCH) $(if $(SHOW_COMMANDS),V=1)
ifneq ($(TARGET_ARCH),$(HOST_ARCH))
mk_kernel += CROSS_COMPILE=$(CURDIR)/$(TARGET_TOOLS_PREFIX)
endif

KERNEL_CONFIG_FILE := kernel/arch/$(TARGET_ARCH)/configs/$(TARGET_KERNEL_CONFIG)
MOD_ENABLED := $(shell grep ^CONFIG_MODULES=y $(KERNEL_CONFIG_FILE))

# I understand Android build system discourage to use submake,
# but I don't want to write a complex Android.mk to build kernel.
# This is the simplest way I can think.
BUILT_KERNEL_TARGET := $(KBUILD_OUTPUT)/arch/$(TARGET_ARCH)/boot/$(KERNEL_TARGET)
$(BUILT_KERNEL_TARGET): $(KERNEL_CONFIG_FILE) | $(KBUILD_OUTPUT)
	$(mk_kernel) $(TARGET_KERNEL_CONFIG)
	$(mk_kernel) $(KERNEL_TARGET) $(if $(MOD_ENABLED),modules)

$(INSTALLED_KERNEL_TARGET): $(BUILT_KERNEL_TARGET) | $(ACP)
	$(transform-prebuilt-to-target)
ifdef TARGET_PREBUILT_MODULES
	$(ACP) -r $(TARGET_PREBUILT_MODULES) $(TARGET_OUT)/lib
else
ifneq ($(MOD_ENABLED),)
	$(mk_kernel) INSTALL_MOD_PATH=$(CURDIR)/$(TARGET_OUT) modules_install
	$(hide) rm -f $(TARGET_OUT)/lib/modules/*/{build,source}
endif
endif

installclean: FILES += $(KBUILD_OUTPUT) $(INSTALLED_KERNEL_TARGET)

TARGET_PREBUILT_KERNEL  := $(INSTALLED_KERNEL_TARGET)

.PHONY: kernel
kernel: $(TARGET_PREBUILT_KERNEL)

endif
