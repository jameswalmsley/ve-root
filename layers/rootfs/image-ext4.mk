LAYER:=rootfs-ext4-image
include $(DEFINE_LAYER)

rootfs-ext4-image:=$(BUILD_rootfs-ext4-image)/rootfs.ext4.img
rootfs-ext4-image.gz:=$(BUILD_rootfs-ext4-image)/rootfs.ext4.img.gz

$(L) += $(rootfs-ext4-image)
$(L) += $(rootfs-ext4-image.gz)

DEPENDS += rootfs

include $(BUILD_LAYER)

$(rootfs-ext4-image):
	-umount $(builddir)/mntfs
	mkdir -p $(dir $@)
	-rm $@.tmp
	fallocate -l $(SYSTEM_IMAGE_SIZE) $@.tmp
	mkfs.ext4 $@.tmp
	-mkdir $(builddir)/mntfs
	mount -o loop -t ext4 $@.tmp $(builddir)/mntfs
	rsync -av $(ROOTFS)/ $(builddir)/mntfs/
	sync
	umount $(builddir)/mntfs
	sync
	rm -rf $(builddir)/mntfs
	mv $@.tmp $@
	touch $@

$(rootfs-ext4-image.gz):
	pv $(rootfs-ext4-image) | pigz -c -9 > $@

$(rootfs-ext4-image.gz): $(rootfs-ext4-image)
