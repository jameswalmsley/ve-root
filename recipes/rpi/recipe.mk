#
# RPI3 Recipe
#
include $(DEFINE_RECIPE)

SYSTEM_IMAGE_SIZE:=2G

#
# Include all required layers.
#
LAYERS += bootloader/u-boot
LAYERS += kernel/linux

#
# Debian based system
#
include $(BASE)/layers/debian/debian.mk

LAYERS += kernel/modules
LAYERS += debian/depmod
LAYERS += rpi-firmware
LAYERS += debian/minimise
LAYERS += rootfs/permissions

#
# 
#
LAYERS += $(ROOTFS_LAYERS)

#
# Add virtual rootfs - sync layer!
#
LAYERS += rootfs

LAYERS += debian/initramfs
LAYERS += debian/bootramfs

LAYERS += overlays

LAYERS += bootloader/bootimage
LAYERS += bootloader/updateimage

LAYERS += rootfs/tarball
LAYERS += rootfs/sysroot
#LAYERS += rootfs/blkdev-image
LAYERS += bootimage
LAYERS += rootfs/image-ext4
LAYERS += sdcard-image

LAYERS += updateimage

include $(BUILD_RECIPE)

.PHONY: flash.info
flash.info:
	@echo "Create sd-card image..."
