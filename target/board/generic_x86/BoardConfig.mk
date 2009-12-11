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
BOARD_USES_TSLIB ?= false

BOARD_KERNEL_CMDLINE ?= root=/dev/ram0 androidboot_hardware=$(TARGET_PRODUCT) acpi_sleep=s3_bios,s3_mode
