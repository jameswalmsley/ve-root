LAYER:=bootloader-bootimage
include $(DEFINE_LAYER)

bootloader-bootimage.fit:=$(BUILD)/$(L)/bootimage.fit
bootloader-bootimage.its:=$(BUILD)/$(L)/bootimage.its

$(L) += $(bootloader-bootimage.fit)
$(L) += $(bootloader-bootimage.its)

DEPENDS += kernel
DEPENDS += debian-bootramfs

include $(BUILD_LAYER)

ifeq ($(BOOTIMAGE_FILES),)
BOOTIMAGE_FILES += $(dtb-file)
BOOTIMAGE_FILES += $(kernel)
BOOTIMAGE_FILES += $(bootramfs)
endif


BOOTIMAGE_OUT:=$(BUILD)/$(L)/bootimage

$(bootloader-bootimage.fit):
	@echo "Generating U-Boot bootimage"
	mkdir -p $(BOOTIMAGE_OUT)
	cp $(kernel) $(BOOTIMAGE_OUT)/Image
	cp $(dtb-file) $(BOOTIMAGE_OUT)/dtree.dtb
	cp $(debian-bootramfs) $(BOOTIMAGE_OUT)/initramfs.cpio.gz
	cd $(BOOTIMAGE_OUT) && dtc -p 0x1000 -I dtb -O dtb dtree.dtb -o devicetree.dtb
	cd $(BOOTIMAGE_OUT) && fdtput -ts devicetree.dtb "/chosen" "bootargs" "$(shell cat $(RECIPE)/bootargs.txt)"
	cp $(bootloader-bootimage.its) $(BOOTIMAGE_OUT)
	cd $(BOOTIMAGE_OUT) && $(MKIMAGE) -D "-I dts -O dtb -p 0x1000" -f bootimage.its $@


$(bootloader-bootimage.fit): $(bootloader-bootimage.its)
$(bootloader-bootimage.fit): $(RECIPE)/bootargs.txt

$(bootloader-bootimage.its):
	python3 $(DEBIAN_PATCH)/generate.py $(BASE_bootloader-bootimage)/bootimage $(dir $(bootloader-bootimage.its)) $(DEBIAN_OS_PATCH_CONFIG)
