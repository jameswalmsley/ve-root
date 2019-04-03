LAYER:=bootramfs
include $(DEFINE_LAYER)

bootramfs:=$(BUILD)/$(L)/bootramfs.cpio.gz
updateramfs:=$(BUILD)/$(L)/updateramfs.cpio.gz

$(L) += $(bootramfs)
$(L) += $(updateramfs)

DEPENDS += initramfs-base

include $(BUILD_LAYER)

BOOTRAMFS_OUT:=$(BUILD)/$(L)/bootramfs
UPDATERAMFS_OUT:=$(BUILD)/$(L)/updateramfs

BOOTFILES += $(ROOTFS)/usr/bin/pv:bin
BOOTFILES += $(ROOTFS)/sbin/resize2fs:sbin
BOOTFILES += $(ROOTFS)/sbin/e2fsck:sbin
BOOTFILES += $(ROOTFS)/sbin/mke2fs:sbin
BOOTFILES += $(ROOTFS)/sbin/mkfs.ext4:sbin
BOOTFILES += $(ROOTFS)/sbin/sfdisk:sbin
BOOTFILES += $(ROOTFS)/bin/chown:bin
BOOTFILES += $(ROOTFS)/lib/aarch64-linux-gnu/libe2p.so.2.3:lib
BOOTFILES += $(ROOTFS)/lib/aarch64-linux-gnu/libe2p.so.2:lib
BOOTFILES += $(ROOTFS)/lib/aarch64-linux-gnu/libext2fs.so.2.4:lib
BOOTFILES += $(ROOTFS)/lib/aarch64-linux-gnu/libext2fs.so.2:lib
BOOTFILES += $(ROOTFS)/lib/aarch64-linux-gnu/libcom_err.so.2.1:lib
BOOTFILES += $(ROOTFS)/lib/aarch64-linux-gnu/libcom_err.so.2:lib
BOOTFILES += $(ROOTFS)/lib/aarch64-linux-gnu/libblkid.so.1.1.0:lib
BOOTFILES += $(ROOTFS)/lib/aarch64-linux-gnu/libblkid.so.1:lib
BOOTFILES += $(ROOTFS)/lib/aarch64-linux-gnu/libuuid.so.1.3.0:lib
BOOTFILES += $(ROOTFS)/lib/aarch64-linux-gnu/libfdisk.so.1:lib
BOOTFILES += $(ROOTFS)/lib/aarch64-linux-gnu/libsmartcols.so.1:lib
BOOTFILES += $(ROOTFS)/lib/aarch64-linux-gnu/libtinfo.so.5:lib


define copy_bootfiles
$(foreach f,$(BOOTFILES),\
cp $(strip $(shell echo $(f) | cut -d : -f1)) $(1)/$(strip $(shell echo $(f) | cut -d : -f2))$(\n)\
)
endef

$(bootramfs):
	mkdir -p $(BOOTRAMFS_OUT)
	rsync -avH --delete $(INITRAMFS_OUT)/* $(BOOTRAMFS_OUT)
	cp $(RECIPE)/ramdisk/bootinit.sh $(BOOTRAMFS_OUT)/init
	$(call copy_bootfiles,$(BOOTRAMFS_OUT))
	cd $(BOOTRAMFS_OUT) && find . | cpio --quiet -H newc -o | gzip -9 -n > $@

$(bootramfs): $(RECIPE)/ramdisk/bootinit.sh

$(updateramfs):
	mkdir -p $(UPDATERAMFS_OUT)
	rsync -avH --delete $(INITRAMFS_OUT)/* $(UPDATERAMFS_OUT)
	cp $(RECIPE)/ramdisk/updateinit.sh $(UPDATERAMFS_OUT)/init
	$(call copy_bootfiles,$(UPDATERAMFS_OUT))
	cd $(UPDATERAMFS_OUT) && find . | cpio --quiet -H newc -o | gzip -9 -n > $@

$(updateramfs): $(RECIPE)/ramdisk/updateinit.sh

$(L).clean:
	rm -rf $(L_bootramfs)
