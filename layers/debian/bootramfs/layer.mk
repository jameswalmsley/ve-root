LAYER:=debian-bootramfs
include $(DEFINE_LAYER)

bootinit.sh:=$(BUILD)/$(L)/ramdisk/bootinit.sh
updateinit.sh:=$(BUILD)/$(L)/ramdisk/updateinit.sh
debian-bootramfs:=$(BUILD)/$(L)/bootramfs.cpio.gz
debian-updateramfs:=$(BUILD)/$(L)/updateramfs.cpio.gz

$(L) += $(bootinit.sh)
$(L) += $(debian-bootramfs)
$(L) += $(updateinit.sh)
$(L) += $(debian-updateramfs)

include $(BUILD_LAYER)

DEBIAN_PACKAGES += pv

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

JQUERY=python3 $(BASE_debian-bootramfs)/query.py

BLK_DEVICES:=$(shell $(JQUERY) $(DEBIAN_OS_PATCH_CONFIG) json '" ".join([*config["block-devices"].keys()])')
BLK_SFFILES:=$(shell $(JQUERY) $(DEBIAN_OS_PATCH_CONFIG) json '" ".join([f["sffile"] for k,f in config["block-devices"].items() if "sffile" in f])')


define copy_bootfiles
$(foreach f,$(BOOTFILES),\
cp $(strip $(shell echo $(f) | cut -d : -f1)) $(1)/$(strip $(shell echo $(f) | cut -d : -f2))$(\n)\
)
endef

define copy_sffiles
$(foreach f,$(BLK_SFFILES),\
cp $(RECIPE)/$(strip $(f)) $(BOOTRAMFS_OUT)/partitions$(\n)\
)
endef


$(foreach f,$(BLK_SFFILES),\
$(debian-bootramfs): $(RECIPE)/$(strip $(f))$(\n)\
)

$(debian-bootramfs):
	mkdir -p $(BOOTRAMFS_OUT)
	rsync -avH --delete $(INITRAMFS_OUT)/* $(BOOTRAMFS_OUT)
	cp $(bootinit.sh) $(BOOTRAMFS_OUT)/init
	$(call copy_bootfiles,$(BOOTRAMFS_OUT))
	-mkdir $(BOOTRAMFS_OUT)/partitions
	$(call copy_sffiles)
	cd $(BOOTRAMFS_OUT) && find . | cpio --quiet -H newc -o | gzip -9 -n > $@

$(debian-bootramfs): $(bootinit.sh)


$(bootinit.sh) $(updateinit.sh):
	python3 $(DEBIAN_PATCH)/generate.py $(BASE_debian-bootramfs)/ramdisk $(dir $(bootinit.sh)) $(DEBIAN_OS_PATCH_CONFIG)

$(bootinit.sh): $(DEBIAN_OS_PATCH_CONFIG)

#
# Synchronise the 
#
$(updateinit.sh): | $(bootinit.sh)

$(bootinit.sh): $(DEBIAN_OS_PATCH_CONFIG)
$(bootinit.sh): $(BASE_debian-bootramfs)/ramdisk/bootinit.sh
$(updateinit.sh): $(BASE_debian-bootramfs)/ramdisk/updateinit.sh

$(debian-updateramfs):
	mkdir -p $(UPDATERAMFS_OUT)
	rsync -avH --delete $(INITRAMFS_OUT)/* $(UPDATERAMFS_OUT)
	cp $(updateinit.sh) $(UPDATERAMFS_OUT)/init
	$(call copy_bootfiles,$(UPDATERAMFS_OUT))
	-mkdir $(UPDATERAMFS_OUT)/partitions
	$(call copy_sffiles)
	cd $(UPDATERAMFS_OUT) && find . | cpio --quiet -H newc -o | gzip -9 -n > $@

$(debian-updateramfs): $(updateinit.sh)


bootramfs:=$(debian-bootramfs)
