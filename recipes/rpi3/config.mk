ARCH:=arm64
CROSS_COMPILE:=aarch64-linux-gnu-

RECIPE_DEB_ARCH:=$(ARCH)
RECIPE_DEB_RELEASE:=bionic
BOOT_IMAGE_SIZE:=48M

QEMU_START:=cp /usr/bin/qemu-aarch64-static $(ROOTFS)/usr/bin
QEMU_DONE:=rm $(ROOTFS)/usr/bin/qemu-aarch64-static
