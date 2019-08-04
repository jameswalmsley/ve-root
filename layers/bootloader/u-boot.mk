LAYER:=bootloader
include $(DEFINE_LAYER)

UBOOT_GIT_URL?=https://github.com/u-boot/u-boot.git
UBOOT_GIT_REF?=master

UBOOT_OUT:=$(BUILD)/$(L)/u-boot
UBOOT_SIGNED_OUT:=$(BUILD)/$(L)/u-boot-signed
UBOOT_SOURCE:=$(SRC_bootloader)/u-boot
UBOOT_CONFIG?=$(RECIPE)/kconfigs/u-boot.config
UBOOT_DEFCONFIG?=rpi_3_defconfig

#
# Define target variables
#
bootloader:=$(BUILD)/$(L)/u-boot/u-boot.bin
bootloader-config:=$(UBOOT_OUT)/.config

ifeq ($(CONFIG_SECURE_BOOT),y)
bootloader-signed:=$(UBOOT_SIGNED_OUT)/u-boot-sign-dtb.bin

# mkimage tool requires a signed fit to ensure we generate a bootloader
# that will work with that fit image.

# We'll generate a fake fit file with the correct keys.
bootloader-build-fit:=$(UBOOT_SIGNED_OUT)/fit/u-boot-build.fit
endif

#
# Hook layer targets
#
$(L) += $(bootloader-config)
$(L) += $(bootloader)

# If CONFIG_SECURE_BOOT != y, then these evaulate to ""
$(L) += $(bootloader-signed)
$(L) += $(bootloader-build-fit)

#
# Register optional targets
#
$(T) += bootloader-config


#
# Specify source checkouts
#
$(call git_clone, u-boot, $(UBOOT_GIT_URL), $(UBOOT_GIT_REF))

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

BOOTLOADER_CONFIG_TARGET:=$(UBOOT_DEFCONFIG)

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


$(bootloader-build-fit):
	mkdir -p $(dir $@)
	cd $(dir $@) && dd if=/dev/urandom bs=1M count=2 of=Image
	cp $(basedir)/build-fit/bootloader-build-fit.its $(dir $@)
	cd $(dir $@) && $(MKIMAGE) -D "-I dts -O dtb -p 0x1000" -f bootloader-build-fit.its -k $(KEY_PATH) $@ 

$(bootloader-build-fit): $(bootloader)

$(bootloader-signed):
	mkdir -p $(UBOOT_SIGNED_OUT)
	cd $(UBOOT_SIGNED_OUT) && dtc -p 0x1000 -I dtb -O dtb $(UBOOT_OUT)/u-boot.dtb -o u-boot.dtb
	cd $(UBOOT_SIGNED_OUT) && $(MKIMAGE) -D "-I dts -O dtb -p 0x1000" -F -k "$(KEY_PATH_ABS)" -K u-boot.dtb -r $(bootloader-build-fit)
	cd $(UBOOT_SIGNED_OUT) && cat $(UBOOT_OUT)/u-boot-nodtb.bin u-boot.dtb > $@

$(bootloader-signed): $(bootloader) $(bootloader-build-fit)

#
# Specify a clean rule.
#
$(L).clean:
	rm -rf $(L_bootloader)
	cd $(UBOOT_SOURCE) && $(MAKE) O=$(UBOOT_OUT) clean mrproper
	cd $(UBOOT_SOURCE) && $(MAKE) mrproper
