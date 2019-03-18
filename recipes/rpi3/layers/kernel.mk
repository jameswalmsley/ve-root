# Define the LAYER name, and instantiate layer.
LAYER:=kernel
include $(DEFINE_LAYER)

#
# Define target variables
#
kernel:=$(BUILD)/$(L)/linux/arch/$(ARCH)/boot/Image
kernel-config:=$(RECIPE)/kconfigs/linux-rpi3.config
dtb-file:=$(BUILD)/$(L)/linux/arch/$(ARCH)/boot/dts/broadcom/bcm2837-rpi-3-b-plus.dtb

#
# Hook layer targets
#
$(L) += $(kernel)
$(L) += $(kernel-config)

#
# Specify source checkouts
#
$(call git_clone, linux, https://github.com/raspberrypi/linux.git, rpi-4.19.y)

#
# Specify layer dependencies
#
RUNAFTER += bootloader

#
# Hook layer into build system.
#
include $(BUILD_LAYER)


#
# Layer Build instructions...
#

KERNEL_SOURCE:=$(S_kernel)/linux
KERNEL_OUT:=$(BUILD)/$(L)/linux
KERNEL_CONFIG_TARGET:=bcmrpi3_defconfig

$(kernel):
	mkdir -p $(KERNEL_OUT)
	cp $(kernel-config) $(KERNEL_OUT)/.config
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules_prepare
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) Image
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) dtbs
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	touch $@

$(kernel): $(kernel-config)

define do_kconfig
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) ARCH=$(ARCH) $(KERNEL_CONFIG_TARGET)
	cp $(KERNEL_OUT)/.config $(kernel-config)
endef

$(kernel-config):
	$(call do_kconfig)

.PHONY:kernel-config
kernel-config: KERNEL_CONFIG_TARGET:=menuconfig
kernel-config:
	$(call do_kconfig)

KERNEL_VERSION:=$(shell cd $(KERNEL_SOURCE) && $(MAKE) --quiet O=$(KERNEL_OUT) ARCH=$(ARCH) kernelversion)

.PHONY: kernelversion
kernelversion:
	@echo $(KERNEL_VERSION)

.PHONY: dtbs
dtbs:
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) dtbs

$(L).clean:
	rm -rf $(L_kernel)
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) clean

