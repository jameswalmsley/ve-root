LAYER:=rootfs-ext4-image
include $(DEFINE_LAYER)

rootfs-ext4-image:=$(BUILD_rootfs-ext4-image)/rootfs.ext4.img

$(L) += $(rootfs-ext4-image)

include $(BUILD_LAYER)

$(rootfs-ext4-image):
	mkdir -p $(dir $@)
	fallocate -l $(SYSTEM_IMAGE_SIZE) $@
	mkfs.ext4 $@
	-mkdir $(builddir)/mntfs
	mount -o loop -t ext4 $@ $(builddir)/mntfs
	rsync -av $(ROOTFS)/ $(builddir)/mntfs/
	sync
	umount $(builddir)/mntfs
	rm -rf $(builddir)/mntfs

