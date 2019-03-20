LAYER:=rootfs-ext4-image
include $(DEFINE_LAYER)

rootfs-ext4-image:=$(OUT)/rootfs.ext4.img

$(L) += $(rootfs-ext4-image)

include $(BUILD_LAYER)

$(rootfs-ext4-image):
	fallocate -l $(SYSTEM_IMAGE_SIZE) $@
	mkfs.ext4 $@
	-mkdir $(OUT)/mntfs
	mount -o loop -t ext4 $@ $(OUT)/mntfs
	rsync -av $(ROOTFS)/ $(OUT)/mntfs/
	sync
	umount $(OUT)/mntfs
	rm -rf $(OUT)/mntfs

