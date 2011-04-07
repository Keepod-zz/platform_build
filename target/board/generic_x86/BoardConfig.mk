# In Eclair this file is included before definitions.mk.
# As a result, my-dir is not defined yet.
# We define our version here as a temporary fix.
define _mydir
$(dir $(lastword $(MAKEFILE_LIST)))
endef

TARGET_DISK_LAYOUT_CONFIG := $(call _mydir)disk_layout.conf

TARGET_CPU_ABI := x86

TARGET_COMPRESS_MODULE_SYMBOLS := false
TARGET_PRELINK_MODULE := false

TARGET_USERIMAGES_USE_EXT2 := true
TARGET_BOOTIMAGE_USE_EXT2 := true
TARGET_USE_DISKINSTALLER := false

# Set /system/bin/sh to mksh
TARGET_SHELL := mksh

BOARD_BOOTIMAGE_MAX_SIZE := 8388608
BOARD_SYSLOADER_MAX_SIZE := 7340032
BOARD_FLASH_BLOCK_SIZE := 512

# the following variables could be overridden
TARGET_NO_BOOTLOADER ?= true
TARGET_NO_RECOVERY ?= true
TARGET_HARDWARE_3D ?= false
TARGET_PROVIDES_INIT_RC ?= true
TARGET_HAS_THIRD_PARTY_APPS ?= false

USE_CUSTOM_RUNTIME_HEAP_MAX ?= "128M"

BOARD_USES_GENERIC_AUDIO ?= false
BOARD_USES_ALSA_AUDIO ?= true
BUILD_WITH_ALSA_UTILS ?= true
BOARD_HAVE_BLUETOOTH ?= true
# Set to true if you have touch screen
BOARD_USES_TSLIB ?= false
# Remove the comment if you are using i915 driver
#BOARD_USES_I915 := true
# This enables the wpa wireless driver
#BOARD_WPA_SUPPLICANT_DRIVER := AWEXT

BOARD_USES_HWOPENGL :=        \
	$(BOARD_USES_I915C)   \
	$(BOARD_USES_I915G)   \
	$(BOARD_USES_I965C)   \
	$(BOARD_USES_I965G)   \
	$(BOARD_USES_NOUVEAU) \
	$(BOARD_USES_R600G)   \
	$(BOARD_USES_VMWGFX)  \

ifeq ($(strip $(sort $(BOARD_USES_HWOPENGL))),true)
BOARD_USES_DRM := true
BOARD_USES_MESA := true
ifeq ($(strip $(BOARD_EGL_CFG)),)
BOARD_EGL_CFG := $(call _mydir)egl.cfg
endif
endif

BOARD_KERNEL_CMDLINE ?= root=/dev/ram0 androidboot_hardware=$(TARGET_PRODUCT) acpi_sleep=s3_bios,s3_mode $(if $(BOARD_USES_DRM),,video=-16)
