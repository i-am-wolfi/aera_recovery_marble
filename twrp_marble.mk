# SPDX-License-Identifier: Apache-2.0
# Produto TWRP/compat para marble.

DEVICE_PATH := device/xiaomi/marble

$(call inherit-product, $(DEVICE_PATH)/device.mk)

PRODUCT_DEVICE := marble
PRODUCT_NAME := twrp_marble
PRODUCT_MODEL := POCO F5
PRODUCT_BRAND := Xiaomi
PRODUCT_MANUFACTURER := Xiaomi

AERA_STATUS_ICONS_ALIGN := center
