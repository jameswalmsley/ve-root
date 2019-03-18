LAYER:=debian-rootfs
LBASE:=$(BASE)/layers/$(LAYER)

include $(DEFINE_LAYER)

#
# Define target variables
#
debian-rootfs-base:=$(LSTAMP)/debian-rootfs-base
debian-rootfs-patch:=$(LSTAMP)/debian-rootfs-patch
debian-rootfs-config:=$(LSTAMP)/debian-rootfs-config

#
# Hook layer targets
#
$(L) += $(debian-rootfs-base)
$(L) += $(debian-rootfs-patch)
$(L) += $(debian-rootfs-config)

RUNAFTER += bootloader
RUNAFTER += kernel

#
# Hook layer into build system.
#
include $(BUILD_LAYER)

#
# Layer Build instructions...
#

ROOTFS_OUT:=$(BUILD)/$(L)/debian-rootfs-base

$(debian-rootfs-base):
	rm -rf $(ROOTFS_OUT)
	cd $(LBASE) && bash genrootfs.sh --arch $(RECIPE_DEB_ARCH) --out $(ROOTFS_OUT) --release $(RECIPE_DEB_RELEASE) --pfile $(RECIPE)/packages.list --efile $(RECIPE)/exclude-packages.list
	$(stamp)

$(debian-rootfs-base): $(RECIPE)/packages.list


$(debian-rootfs-patch):
	rm -rf $(ROOTFS)
	mkdir -p $(ROOTFS)
	rsync -av $(ROOTFS_OUT)/* $(ROOTFS)/
	python3 $(LBASE)/rootfspatch/generate.py $(LBASE)/rootfspatch/rootfs $(ROOTFS) $(RECIPE)/config.json
	$(stamp)

$(debian-rootfs-patch): $(debian-rootfs-base)

$(debian-rootfs-config):
	$(QEMU_START)
	cd $(ROOTFS) && chroot . /bin/bash -c "bash /setup.sh"
	$(QEMU_DONE)
	rm $(ROOTFS)/setup.sh
	$(stamp)

$(debian-rootfs-config): $(debian-rootfs-patch)

$(L).clean:
	rm -rf $(L_debian-rootfs)
	rm -rf $(ROOTFS_OUT)

