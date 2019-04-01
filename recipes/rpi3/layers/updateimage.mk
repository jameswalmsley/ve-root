LAYER:=updateimage
include $(DEFINE_LAYER)

updateimage.fit:=$(BUILD)/$(L)/updateimage.fit

$(L) += $(updateimage.fit)

DEPENDS += kernel
DEPENDS += bootramfs

include $(BUILD_LAYER)

UPDATEIMAGE_OUT:=$(BUILD)/$(L)/updateimage

$(updateimage.fit):
	@echo "Generating U-Boot updateimage"
	mkdir -p $(UPDATEIMAGE_OUT)
	cp $(kernel) $(UPDATEIMAGE_OUT)
	cp $(RPI_FW)/boot/bcm2710-rpi-3-b-plus.dtb $(UPDATEIMAGE_OUT)/dtree.dtb
	cp $(RPI_FW)/boot/overlays/pi3-miniuart-bt.dtbo $(UPDATEIMAGE_OUT)
	cp $(RPI_FW)/boot/overlays/pi3-disable-bt.dtbo $(UPDATEIMAGE_OUT)
	cp $(updateramfs) $(UPDATEIMAGE_OUT)/initramfs.cpio.gz
	cd $(UPDATEIMAGE_OUT) && dtc -p 0x1000 -I dtb -O dtb dtree.dtb -o devicetree.dtb
	cd $(UPDATEIMAGE_OUT) && fdtput -ts devicetree.dtb "/chosen" "bootargs" "$(shell cat $(RECIPE)/bootargs.txt)"
	cp $(RECIPE)/bootimage.its $(UPDATEIMAGE_OUT)
	cd $(UPDATEIMAGE_OUT) && $(MKIMAGE) -D "-I dts -O dtb -p 0x1000" -f bootimage.its $@

