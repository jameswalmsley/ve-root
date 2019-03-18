LAYER:=bootramfs
include $(DEFINE_LAYER)

bootramfs:=$(BUILD)/$(L)/bootramfs.cpio.gz

$(L) += $(bootramfs)

DEPENDS += initramfs-base

include $(BUILD_LAYER)


BOOTRAMFS_OUT:=$(BUILD)/$(L)/bootramfs

$(bootramfs):
	mkdir -p $(BOOTRAMFS_OUT)
	rsync -avH --delete $(INITRAMFS_OUT)/* $(BOOTRAMFS_OUT)
	cp $(RECIPE)/ramdisk/bootinit.sh $(BOOTRAMFS_OUT)/init
	cd $(BOOTRAMFS_OUT) && find . | cpio --quiet -H newc -o | gzip -9 -n > $@

$(bootramfs): $(RECIPE)/ramdisk/bootinit.sh


$(L).clean:
	rm -rf $(L_bootramfs)