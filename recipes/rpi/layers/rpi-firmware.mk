LAYER=rpi-firmware
include $(DEFINE_LAYER)

#
# Define target variables
#
rpi-firmware:=$(LSTAMP)/rpi-firmware

#
# Hook layer targets
#
$(L) += $(rpi-firmware)

#
# Specify source checkouts
#
$(call git_clone, linux-firmware, https://kernel.googlesource.com/pub/scm/linux/kernel/git/firmware/linux-firmware.git, master)

#
# Specify layer dependencies
#
RUNAFTER += kernel-modules
DEPENDS += debian-provision

#
# Hook layer into build system.
#
include $(BUILD_LAYER)

#
# Layer build instructions...
#
FIRMWARE_OUT:=$(BUILD)/$(L)/linux-firmware
FIRMWARE_SOURCE:=$(SRC_rpi-firmware)/linux-firmware

$(rpi-firmware):
	mkdir -p $(ROOTFS)/lib/firmware/brcm
	cp $(FIRMWARE_SOURCE)/brcm/brcmfmac43455-sdio.bin $(ROOTFS)/lib/firmware/brcm/
	cp $(FIRMWARE_SOURCE)/brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.txt $(ROOTFS)/lib/firmware/brcm/brcmfmac43455-sdio.txt
	$(stamp)


$(L).clean:
	rm -rf $(L_rpi-firmware)