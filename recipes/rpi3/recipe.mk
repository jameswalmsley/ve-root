#
# RPI3 Recipe
#
include $(DEFINE_RECIPE)

UBOOT_GIT_REF?=v2019.01

LINUX_GIT_URL:=https://github.com/raspberrypi/linux.git
LINUX_GIT_REF:=rpi-4.19.y

SYSTEM_IMAGE_SIZE:=500M

#
# Include all required layers.
#
LAYERS += bootloader/u-boot
LAYERS += kernel/linux
LAYERS += debian/debootstrap
LAYERS += debian/provision
LAYERS += debian/os-patch
LAYERS += debian/full-upgrade
LAYERS += debian/packages
LAYERS += kernel/modules
LAYERS += debian/depmod
LAYERS += debian/customise
LAYERS += rootfs/permissions
LAYERS += debian/configure
LAYERS += rpi-firmware
LAYERS += debian/minimise

#
# Add virtual rootfs - sync layer!
#
LAYERS += rootfs

LAYERS += initramfs-base
LAYERS += bootramfs
LAYERS += bootimage

LAYERS += rootfs/tarball
LAYERS += rootfs/image-ext4

LAYERS += rootfs/sysroot

include $(BUILD_RECIPE)
