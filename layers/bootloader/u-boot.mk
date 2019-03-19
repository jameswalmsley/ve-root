LAYER:=bootloader
include $(DEFINE_LAYER)

UBOOT_OUT:=$(BUILD)/$(L)/u-boot
UBOOT_SOURCE:=$(S_bootloader)/u-boot
UBOOT_CONFIG:=$(RECIPE)/kconfigs/u-boot.config

#
# Define target variables
#
bootloader:=$(BUILD)/$(L)/u-boot/u-boot.bin
bootloader-config:=$(UBOOT_OUT)/.config

#
# Hook layer targets
#
$(L) += $(bootloader)
$(L) += $(bootloader-config)


#
# Specify source checkouts
#
$(call git_clone, u-boot, https://github.com/u-boot/u-boot.git, master)

#
# Specify layer dependencys and run orders.
#

#
# Hook layer into build system.
#
include $(BUILD_LAYER)

#
# Layer Build instructions...
#
MKIMAGE:=$(UBOOT_OUT)/tools/mkimage

$(bootloader):
	cd $(UBOOT_SOURCE) && $(MAKE) O=$(UBOOT_OUT) CROSS_COMPILE=$(CROSS_COMPILE)
	$(stamp)

$(bootloader): $(bootloader-config)

BOOTLOADER_CONFIG_TARGET:=rpi_3_defconfig

define do_bconfig
	cd $(UBOOT_SOURCE) && $(MAKE) O=$(UBOOT_OUT) CROSS_COMPILE=$(CROSS_COMPILE) $(BOOTLOADER_CONFIG_TARGET)
	cp $(UBOOT_OUT)/.config $(UBOOT_CONFIG)
endef

$(bootloader-config):
	mkdir -p $(UBOOT_OUT)
	cp $(UBOOT_CONFIG) $(bootloader-config)
	

$(bootloader-config): $(UBOOT_CONFIG)

.PHONY: bootloader-config
bootloader-config: BOOTLOADER_CONFIG_TARGET:=menuconfig
bootloader-config:
	cp $(UBOOT_CONFIG) $(UBOOT_OUT)/.config
	$(call do_bconfig)

$(UBOOT_CONFIG):
	$(call do_bconfig)
	cp $(UBOOT_OUT)/.config $@
#
# Specify a clean rule.
#
$(L).clean:
	rm -rf $(L_bootloader)
	cd $(UBOOT_SOURCE) && $(MAKE) O=$(UBOOT_OUT) clean mrproper
	cd $(UBOOT_SOURCE) && $(MAKE) mrproper
