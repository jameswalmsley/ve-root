LAYER:=debian-customise
include $(DEFINE_LAYER)

#
# Define target variables
#
custom-rootfs:=$(LSTAMP)/custom-rootfs
custom-configure:=$(LSTAMP)/custom-configure

#
# Hook layer targets.
#
$(L) += $(custom-rootfs)
$(L) += $(custom-configure)

DEPENDS += debian-rootfs
DEPENDS += kernel-modules

#
# Hook layer into build system.
#
include $(BUILD_LAYER)

#
# Layer Build instructions
#

$(custom-rootfs):
	rsync -av --checksum --chown=root:root --chmod=D755,F644 $(RECIPE)/rootfs/ $(ROOTFS)/
ifeq ($(ENABLE_DEV),y)
	rsync -av --checksum --chown=root:root --chmod=D755,F644 $(RECIPE)/dev-rootfs/ $(ROOTFS)/
endif
	$(stamp)


$(custom-rootfs): $(shell find $(RECIPE)/rootfs -type f) $(shell find $(RECIPE)/dev-rootfs -type f)

KMOD_VERSION=$(notdir $(shell find $(ROOTFS)/lib/modules/ -name $(KERNEL_VERSION)*))

.PHONY: kmod_version
kmod_version:
	echo $(KMOD_VERSION)

$(custom-configure):
	$(QEMU_START)
	cp $(RECIPE)/scripts/configure.sh $(ROOTFS)
	cp $(RECIPE)/dev-packages.list $(ROOTFS)
	cp $(RECIPE)/permissions.list $(ROOTFS)
	chroot $(ROOTFS) /bin/bash /configure.sh $(KMOD_VERSION)
	rm $(ROOTFS)/configure.sh
	rm $(ROOTFS)/dev-packages.list
	rm $(ROOTFS)/permissions.list
	$(QEMU_DONE)
	$(stamp)

$(custom-configure): $(custom-rootfs)
$(custom-configure): $(RECIPE)/dev-packages.list
$(custom-configure): $(RECIPE)/scripts/configure.sh

