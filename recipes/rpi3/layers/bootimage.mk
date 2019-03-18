LAYER:=bootimage
include $(DEFINE_LAYER)

bootimage.fit:=$(BUILD)/$(L)/bootimage.fit
bootimage:=$(LSTAMP)/bootimage
memory-overlay:=$(BUILD)/$(L)/rpi3-memory.dtbo

$(L) += $(bootimage.fit)
$(L) += $(bootimage)
$(L) += $(memory-overlay)

$(call git_clone, rpi-firmware, https://github.com/raspberrypi/firmware.git, master)

DEPENDS += kernel
DEPENDS += bootramfs
DEPENDS += bootloader

include $(BUILD_LAYER)

BOOT:=$(OUT)/boot

BOOTIMAGE_OUT:=$(BUILD)/$(L)/bootimage
RPI_FW:=$(S_bootimage)/rpi-firmware

$(bootimage.fit):
	@echo "Generating U-Boot bootimage"
	mkdir -p $(BOOTIMAGE_OUT)
	cp $(kernel) $(BOOTIMAGE_OUT) 
	cp $(RPI_FW)/boot/bcm2710-rpi-3-b-plus.dtb $(BOOTIMAGE_OUT)/dtree.dtb
	cp $(RPI_FW)/boot/overlays/pi3-miniuart-bt.dtbo $(BOOTIMAGE_OUT)
	cp $(RPI_FW)/boot/overlays/pi3-disable-bt.dtbo $(BOOTIMAGE_OUT)
	cp $(bootramfs) $(BOOTIMAGE_OUT)/initramfs.cpio.gz
	cd $(BOOTIMAGE_OUT) && dtc -p 0x1000 -I dtb -O dtb dtree.dtb -o devicetree.dtb
	cd $(BOOTIMAGE_OUT) && fdtput -ts devicetree.dtb "/chosen" "bootargs" "$(shell cat $(RECIPE)/bootargs.txt)"
	cp $(RECIPE)/bootimage.its $(BOOTIMAGE_OUT)
	cd $(BOOTIMAGE_OUT) && $(MKIMAGE) -D "-I dts -O dtb -p 0x1000" -f bootimage.its $@

$(bootimage.fit): $(RECIPE)/bootimage.its
$(bootimage.fit): $(RECIPE)/bootargs.txt

$(bootimage):
	@echo "Build /boot filesystem"
	-rm -rf $(BOOT)
	mkdir -p $(BOOT)
	cp $(RPI_FW)/boot/bootcode.bin $(BOOT)
	cp $(RPI_FW)/boot/start.elf $(BOOT)
	cp $(RPI_FW)/boot/fixup.dat $(BOOT)
	cp $(bootimage.fit) $(BOOT)
	cp $(bootloader) $(BOOT)
	cp $(RECIPE)/boot/config.txt $(BOOT)
	#cp -r $(RPI_FW)/boot/overlays $(BOOT)
	#cp $(RPI_FW)/boot/bcm2710-rpi-3-b-plus.dtb $(BOOT)
	#cp $(kernel) $(BOOT)/kernel8.img
	$(stamp)

$(bootimage): $(RECIPE)/boot/config.txt

$(bootimage): $(bootimage.fit)

