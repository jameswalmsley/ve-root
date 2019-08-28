LAYER:=kernel-modules
include $(DEFINE_LAYER)

kernel-modules:=$(LSTAMP)/modules

$(L) += $(kernel-modules)

DEPENDS += debian-rootfs
RUNAFTER += kernel

include $(BUILD_LAYER)

$(kernel-modules):
	rm -rf $(ROOTFS)/lib/modules
	cd $(KERNEL_SOURCE) && $(MAKE) O=$(KERNEL_OUT) ARCH=$(ARCH) modules_install INSTALL_MOD_PATH=$(ROOTFS)
	$(stamp)

$(kernel-modules): $(kernel)
