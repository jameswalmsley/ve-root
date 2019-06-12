LAYER:=debian-initramfs
include $(DEFINE_LAYER)

debian-initramfs:=$(LSTAMP)/initramfs-base

$(L) += $(debian-initramfs)

DEPENDS += debian-provision

include $(BUILD_LAYER)

DEBIAN_PACKAGES += initramfs-tools

INITRAMFS_OUT:=$(BUILD)/$(L)/initramfs-base

$(debian-initramfs):
	@echo "Building debian-initramfs"
	mkdir -p $(INITRAMFS_OUT)
	-umount $(ROOTFS)/mnt
	mount --bind $(INITRAMFS_OUT) $(ROOTFS)/mnt
	$(QEMU_START)
	chroot $(ROOTFS) mkinitramfs -v -o /mnt/initramfs v0.0.1
	$(QEMU_DONE)
	cd $(INITRAMFS_OUT) && zcat initramfs | cpio -idmv
	$(stamp)
