LAYER:=bootimage
include $(DEFINE_LAYER)

bootimage:=$(LSTAMP)/bootimage

$(L) += $(bootimage)

$(call git_clone, rpi-firmware, https://github.com/raspberrypi/firmware.git, master)

DEPENDS += kernel
DEPENDS += bootloader
DEPENDS += bootloader-bootimage

include $(BUILD_LAYER)

BOOT:=$(OUT)/boot

RPI_FW:=$(SRC_bootimage)/rpi-firmware
dtb-file:=$(RPI_FW)/boot/bcm2710-rpi-3-b-plus.dtb

$(bootimage):
	@echo "Build /boot filesystem"
	-rm -rf $(BOOT)
	mkdir -p $(BOOT)
	cp $(RPI_FW)/boot/bootcode.bin $(BOOT)
	cp $(RPI_FW)/boot/start.elf $(BOOT)
	cp $(RPI_FW)/boot/fixup.dat $(BOOT)
	cp $(bootloader-bootimage.fit) $(BOOT)
	cp $(bootloader) $(BOOT)
	cp $(RECIPE)/boot/config.txt $(BOOT)
	$(stamp)

$(bootimage): $(RECIPE)/boot/config.txt

$(bootimage): $(bootimage.fit)

