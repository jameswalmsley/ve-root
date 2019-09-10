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
dtb-file:=$(RPI_FW)/boot/bcm2711-rpi-4-b.dtb

$(bootimage):
	@echo "Build /boot filesystem"
	-rm -rf $(BOOT)
	mkdir -p $(BOOT)
	cp $(RPI_FW)/boot/bootcode.bin $(BOOT)
	cp $(RPI_FW)/boot/start.elf $(BOOT)
	cp $(RPI_FW)/boot/fixup.dat $(BOOT)
ifeq ($(VARIANT),rpi4)
	cp -rv $(RPI_FW)/boot/* $(BOOT)
	#cp $(RPI_FW)/boot/start4* $(BOOT)
endif
	cp $(kernel) $(BOOT)/kernel8.img
	cp $(dtb-file) $(BOOT)
	cp $(RECIPE)/bootargs.txt $(BOOT)/cmdline.txt
	cp $(bootloader-bootimage.fit) $(BOOT)
	cp $(bootloader) $(BOOT)
	cp $(RECIPE)/boot/config.txt $(BOOT)/config.txt
ifeq ($(CONFIG_USE_RPI_BOOTLOADER),y)
	cp $(RECIPE)/boot/config-rpi-bootloader.txt $(BOOT)/config.txt
endif
	$(stamp)

$(bootimage): $(RECIPE)/boot/config.txt

$(bootimage): $(bootimage.fit)

