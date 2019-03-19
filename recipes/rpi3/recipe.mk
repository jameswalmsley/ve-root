#
# RPI3 Recipe
#
include $(DEFINE_RECIPE)

LINUX_GIT_URL:=https://github.com/raspberrypi/linux.git
LINUX_GIT_REF:=rpi-4.19.y


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

include $(BUILD_RECIPE)
