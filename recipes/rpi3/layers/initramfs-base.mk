LAYER:=initramfs-base
include $(DEFINE_LAYER)

initramfs-base:=$(LSTAMP)/initramfs-base

$(L) += $(initramfs-base)

DEPENDS += debian-rootfs


include $(BUILD_LAYER)


INITRAMFS_OUT:=$(BUILD)/$(L)/initramfs-base

$(initramfs-base):
	@echo "Building initramfs-base"
	mkdir -p $(INITRAMFS_OUT)
	-umount $(ROOTFS)/mnt
	mount --bind $(INITRAMFS_OUT) $(ROOTFS)/mnt
	$(QEMU_START)
	chroot $(ROOTFS) mkinitramfs -v -o /mnt/initramfs
	$(QEMU_DONE)
	umount $(ROOTFS)/mnt
	cd $(INITRAMFS_OUT) && zcat initramfs | cpio -idmv
	rm $(INITRAMFS_OUT)/initramfs
	$(stamp)

