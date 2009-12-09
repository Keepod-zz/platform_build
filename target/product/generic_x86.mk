# This is a generic product that isn't specialized for a specific device.
# It includes the base Android-x86 platform.

PRODUCT_PACKAGES := \
    GlobalTime \
    JETBoy \
    LunarLander \
    NotePad \
    PinyinIME \
    RSSReader \
    Snake

THIRD_PARTY_APPS = \
    ConnectBot \
    FileManager \


$(call inherit-product,$(SRC_TARGET_DIR)/product/generic.mk)

# Overrides
PRODUCT_BRAND := generic_x86
PRODUCT_DEVICE := generic_x86
PRODUCT_NAME := generic_x86
PRODUCT_POLICY := android.policy_mid
PRODUCT_PROPERTY_OVERRIDES += \
	ro.com.android.dataroaming=true

GENERIC_X86_CONFIG_MK := $(SRC_TARGET_DIR)/board/generic_x86/BoardConfig.mk
GENERIC_X86_ANDROID_MK := $(SRC_TARGET_DIR)/board/generic_x86/AndroidBoard.mk
