# Define the LAYER name, and instantiate layer.
LAYER:=kernel
include $(DEFINE_LAYER)

LINUX_GIT_URL?=https://github.com/torvalds/linux.git
LINUX_GIT_REF?=master

KERNEL_OUT:=$(BUILD)/$(L)/linux
KERNEL_SOURCE:=$(SRC_kernel)/linux
LINUX_CONFIG?=$(RECIPE)/kconfigs/linux.config
LINUX_DEFCONFIG?=bcmrpi3_defconfig

#
# Define target variables
#
kernel:=$(BUILD)/$(L)/linux/arch/$(ARCH)/boot/Image
kernel-config:=$(KERNEL_OUT)/.config
dtb-file:=$(BUILD)/$(L)/linux/arch/$(ARCH)/boot/dts/broadcom/bcm2837-rpi-3-b-plus.dtb

#
# Hook layer targets
#
$(L) += $(kernel)
$(L) += $(kernel-config)
$(L) += $(LINUX_CONFIG)

#
# Register optional targets.
#
$(T) += kernel-config
$(T) += kernelversion
$(T) += dtbs

#
# Specify source checkouts
#
$(call git_clone, linux, $(LINUX_GIT_URL), $(LINUX_GIT_REF))

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
$(kernel):
	mkdir -p $(KERNEL_OUT)
	cp $(kernel-config) $(KERNEL_OUT)/.config
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules_prepare
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) Image
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) dtbs
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules
	touch $@

$(kernel): $(kernel-config)

KERNEL_CONFIG_TARGET:=$(LINUX_DEFCONFIG)

define do_kconfig
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) $(KERNEL_CONFIG_TARGET)
	cp $(KERNEL_OUT)/.config $(kernel-config)
endef

$(kernel-config):
	mkdir -p $(KERNEL_OUT)
	cp $(LINUX_CONFIG) $(kernel-config)

$(kernel-config): $(LINUX_CONFIG)

.PHONY:kernel-config
kernel-config: KERNEL_CONFIG_TARGET:=menuconfig

kernel-config:
	cp $(LINUX_CONFIG) $(KERNEL_OUT)/.config
	$(call do_kconfig)

$(LINUX_CONFIG):
	$(call do_kconfig)
	cp $(KERNEL_OUT)/.config $@

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
