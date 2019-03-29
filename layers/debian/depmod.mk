LAYER:=debian-depmod
include $(DEFINE_LAYER)

debian-depmod:=$(LSTAMP)/depmod

$(L) += $(debian-depmod)

DEPENDS += kernel-modules

include $(BUILD_LAYER)

KMOD_VERSION=$(notdir $(shell find $(ROOTFS)/lib/modules/ -name $(KERNEL_VERSION)*))

$(debian-depmod):
	$(QEMU_START)
	chroot $(ROOTFS) depmod $(KMOD_VERSION)
	$(QEMU_DONE)
	$(stamp)
