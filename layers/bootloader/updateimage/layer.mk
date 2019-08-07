LAYER:=bootloader-updateimage
include $(DEFINE_LAYER)

bootloader-updateimage-suffix:=

ifneq ($(CONFIG_SECURE_BOOT),y)
bootloader-updateimage-suffix:=$(strip $(bootloader-updateimage-suffix)).signed
endif

bootloader-updateimage.fit:=$(BUILD)/$(L)/updateimage$(bootloader-updateimage-suffix).fit
bootloader-updateimage.its:=$(BUILD)/$(L)/updateimage.its

$(L) += $(bootloader-updateimage.fit)
$(L) += $(bootloader-updateimage.its)

DEPENDS += kernel
DEPENDS += debian-bootramfs

include $(BUILD_LAYER)

ifeq ($(UPDATEIMAGE_FILES),)
UPDATEIMAGE_FILES += $(dtb-file)
UPDATEIMAGE_FILES += $(kernel)
UPDATEIMAGE_FILES += $(bootramfs)
endif


UPDATEIMAGE_OUT:=$(BUILD)/$(L)/bootimage

$(bootloader-updateimage.fit):
	@echo "Generating U-Boot updateimage"
	mkdir -p $(UPDATEIMAGE_OUT)
	cp $(kernel) $(UPDATEIMAGE_OUT)/Image
	cp $(dtb-file) $(UPDATEIMAGE_OUT)/dtree.dtb
	cp $(debian-updateramfs) $(UPDATEIMAGE_OUT)/initramfs.cpio.gz
	cd $(UPDATEIMAGE_OUT) && dtc -p 0x1000 -I dtb -O dtb dtree.dtb -o devicetree.dtb
	cd $(UPDATEIMAGE_OUT) && fdtput -ts devicetree.dtb "/chosen" "bootargs" "$(shell cat $(bootloader-bootargs))"
	cp $(bootloader-updateimage.its) $(UPDATEIMAGE_OUT)
ifneq ($(CONFIG_SECURE_BOOT),y)
	cd $(UPDATEIMAGE_OUT) && $(MKIMAGE) -D "-I dts -O dtb -p 0x1000" -f updateimage.its $@
else
	cd $(UPDATEIMAGE_OUT) && $(MKIMAGE) -D "-I dts -O dtb -p 0x1000" -f updateimage.its -k $(KEY_PATH_ABS) $@
endif


$(bootloader-updateimage.fit): $(bootloader-updateimage.its)
$(bootloader-updateimage.fit): $(bootloader-bootargs)

$(bootloader-updateimage.its):
	python3 $(DEBIAN_PATCH)/generate.py $(BASE_bootloader-updateimage)/updateimage $(dir $(bootloader-updateimage.its)) $(DEBIAN_PATCH_CONFIG)

$(bootloader-updateimage.its): $(BASE_bootloader-updateimage)/updateimage/updateimage.its
