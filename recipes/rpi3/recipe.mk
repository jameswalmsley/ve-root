#
# RPI3 Recipe
#
include $(DEFINE_RECIPE)

UBOOT_GIT_REF?=v2019.01

LINUX_GIT_URL:=https://github.com/raspberrypi/linux.git
LINUX_GIT_REF:=rpi-4.19.y

SYSTEM_IMAGE_SIZE:=600M

#
# Include all required layers.
#
LAYERS += bootloader/u-boot
LAYERS += kernel/linux
LAYERS += debian/debootstrap
LAYERS += debian/provision
LAYERS += debian/full-upgrade
LAYERS += debian/packages
LAYERS += debian/os-patch
LAYERS += kernel/modules
LAYERS += debian/depmod
LAYERS += debian/customise
LAYERS += debian/configure
LAYERS += rpi-firmware
LAYERS += debian/minimise
LAYERS += rootfs/permissions

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
LAYERS += rootfs/image-ext4
LAYERS += rootfs/sysroot

LAYERS += bootimage
LAYERS += updateimage

include $(BUILD_RECIPE)
