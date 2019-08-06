LAYER:=rootfs-ext4-image
include $(DEFINE_LAYER)

rootfs-ext4-suffix:=

ifeq ($(CONFIG_ENCRYPTED_ROOTFS),y)
rootfs-ext4-suffix:=.encrypted
endif

rootfs-ext4-image:=$(BUILD_rootfs-ext4-image)/rootfs.ext4$(rootfs-ext4-suffix).img
rootfs-ext4-image.gz:=$(BUILD_rootfs-ext4-image)/rootfs.ext4$(rootfs-ext4-suffix).img.gz

$(L) += $(rootfs-ext4-image)
$(L) += $(rootfs-ext4-image.gz)

DEPENDS += rootfs

include $(BUILD_LAYER)

$(rootfs-ext4-image):
	-umount $(builddir)/mntfs
	mkdir -p $(dir $@)
	-rm $@.tmp
	fallocate -l $(SYSTEM_IMAGE_SIZE) $@.tmp
	-mkdir $(builddir)/mntfs

ifeq ($(CONFIG_ENCRYPTED_ROOTFS),y)
	-cryptsetup luksClose rbImage
	$(CONFIG_ENCRYPTED_ROOTFS_PASSPHRASE) | cryptsetup -q luksFormat $@.tmp -
	$(CONFIG_ENCRYPTED_ROOTFS_PASSPHRASE) | cryptsetup luksOpen $@.tmp rbImage -
	mkfs.ext4 /dev/mapper/rbImage
	mount /dev/mapper/rbImage $(builddir)/mntfs
else
	mkfs.ext4 $@.tmp
	mount -o loop -t ext4 $@.tmp $(builddir)/mntfs
endif
	rsync -av $(ROOTFS)/ $(builddir)/mntfs/
	sync
ifeq ($(CONFIG_EXT4_IMAGE_FIRST_FLASH),y)	
	touch $(builddir)/mntfs/.first-flash
endif
	umount $(builddir)/mntfs
	sync
	rm -rf $(builddir)/mntfs
ifeq ($(CONFIG_ENCRYPTED_ROOTFS),y)	
	cryptsetup luksClose rbImage
endif
	mv $@.tmp $@
	touch $@

$(rootfs-ext4-image.gz):
	pv $(rootfs-ext4-image) | pigz -c -9 > $@

$(rootfs-ext4-image.gz): $(rootfs-ext4-image)
