ARCH:=arm64
CROSS_COMPILE:=aarch64-linux-gnu-

RECIPE_DEB_ARCH:=$(ARCH)
RECIPE_DEB_RELEASE:=bionic
BOOT_IMAGE_SIZE:=48M

LINUX_GIT_URL:=https://github.com/VitalElement/linux.git
LINUX_GIT_REF:=ve-rpi-4.10.y
#
# Default UBOOT URL.
#
UBOOT_GIT_URL:=https://github.com/VitalElement/u-boot.git
UBOOT_GIT_REF:=v2019.01-ve-rpi3

ifeq ($(VARIANT),rpi3)
dtb-name:=broadcom/bcm2710-rpi-3-b.dtb
endif

ifeq ($(VARIANT),rpi4)
DEBIAN_PATCH_FILE:=config-rpi4.json
LINUX_GIT_URL:=https://github.com/raspberrypi/linux.git
LINUX_GIT_REF:=rpi-4.19.y
LINUX_DEFCONFIG:=bcm2711_defconfig
LINUX_CONFIG:=$(RECIPE)/kconfigs/linux-rpi4.config
dtb-name:=broadcom/bcm2711-rpi-4-b.dtb

UBOOT_GIT_URL:=https://github.com/u-boot/u-boot.git
#UBOOT_GIT_REF:=ag/v2019.07-rpi4-wip
UBOOT_GIT_REF:=master
UBOOT_CONFIG:=$(RECIPE)/kconfigs/u-boot-rpi4.config
UBOOT_DEFCONFIG:=rpi_4_defconfig

bootloader-bootargs:=$(RECIPE)/bootargs-rpi4.txt
endif

