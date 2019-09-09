LAYER:=sdcard-image
include $(DEFINE_LAYER)

sdcard-image:=$(LSTAMP)/sdcard.img

$(L) += $(sdcard-image)

DEPENDS += rootfs-ext4-image
DEPENDS += bootloader-bootimage
DEPENDS += bootimage

include $(BUILD_LAYER)

$(sdcard-image):
	$(pretty_start_task)
	rm -rf $(OUT)/sdcard.img
	fallocate -l 5G $(OUT)/sdcard.img
	sfdisk $(OUT)/sdcard.img < $(RECIPE)/rpi4.sfdisk
	$(RECIPE)/scripts/format-sync-image.sh $(OUT)
	$(stamp)


$(sdcard-image): $(RECIPE)/scripts/format-sync-image.sh
$(sdcard-image): $(shell find -type f $(RECIPE)/configfs)
