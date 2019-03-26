#
# RPI3 Recipe
#
include $(DEFINE_RECIPE)

UBOOT_GIT_REF?=v2019.01

LINUX_GIT_URL:=https://github.com/raspberrypi/linux.git
LINUX_GIT_REF:=rpi-4.19.y

SYSTEM_IMAGE_SIZE:=400M

#
# Include all required layers.
#
LAYERS += bootloader/u-boot
LAYERS += kernel/linux
LAYERS += debian/rootfs
LAYERS += kernel-modules
LAYERS += debian-customise
LAYERS += rpi-firmware
LAYERS += initramfs-base
LAYERS += bootramfs
LAYERS += bootimage
LAYERS += rootfs/tarball
LAYERS += rootfs/image-ext4
LAYERS += rootfs/sysroot

include $(BUILD_RECIPE)
