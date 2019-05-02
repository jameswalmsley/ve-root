LAYER:=kernel-modules
include $(DEFINE_LAYER)

kernel-modules:=$(LSTAMP)/modules

$(L) += $(kernel-modules)

DEPENDS += debian-provision
DEPENDS += kernel

include $(BUILD_LAYER)

$(kernel-modules):
	rm -rf $(ROOTFS)/lib/modules
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules_install INSTALL_MOD_PATH=$(ROOTFS)
	$(stamp)

