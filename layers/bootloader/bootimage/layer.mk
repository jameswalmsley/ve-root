LAYER:=bootloader-bootimage
include $(DEFINE_LAYER)

bootloader-bootimage.fit:=$(BUILD)/$(L)/bootimage.fit
bootloader-bootimage.its:=$(BUILD)/$(L)/bootimage.its

bootloader-bootargs?=$(RECIPE)/bootargs.txt

$(L) += $(bootloader-bootimage.fit)
$(L) += $(bootloader-bootimage.its)

DEPENDS += bootloader
DEPENDS += kernel
DEPENDS += bootloader
DEPENDS += debian-bootramfs

include $(BUILD_LAYER)

BOOTIMAGE_FILES += $(dtb-file)
BOOTIMAGE_FILES += $(kernel)
BOOTIMAGE_FILES += $(debian-bootramfs)

BOOTIMAGE_OUT:=$(BUILD)/$(L)/bootimage

$(bootloader-bootimage.fit):
	@echo "Generating U-Boot bootimage"
	mkdir -p $(BOOTIMAGE_OUT)
	cp $(BOOTIMAGE_FILES) $(BOOTIMAGE_OUT)
	cd $(BOOTIMAGE_OUT) && dtc -p 0x1000 -I dtb -O dtb $(notdir $(dtb-file)) -o devicetree.dtb
	cd $(BOOTIMAGE_OUT) && fdtput -ts devicetree.dtb "/chosen" "bootargs" "$(shell cat $(bootloader-bootargs))"
	cp $(bootloader-bootimage.its) $(BOOTIMAGE_OUT)
	cd $(BOOTIMAGE_OUT) && $(MKIMAGE) -D "-I dts -O dtb -p 0x1000" -f bootimage.its $@


$(bootloader-bootimage.fit): $(bootloader-bootimage.its)
$(bootloader-bootimage.fit): $(bootloader-bootargs)

$(bootloader-bootimage.its):
	python3 $(DEBIAN_PATCH)/generate.py $(BASE_bootloader-bootimage)/bootimage $(dir $(bootloader-bootimage.its)) $(DEBIAN_PATCH_CONFIG)

$(bootloader-bootimage.its): $(BASE_bootloader-bootimage)/bootimage/bootimage.its