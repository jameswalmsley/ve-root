DEBIAN_PATCH:=$(BASE)/layers/debian/.scripts/rootfspatch
DEBIAN_PATCH_FILE?=config.json
DEBIAN_PATCH_CONFIG:=$(call select_file,$(TOP)/$(DEBIAN_PATCH_FILE),$(RECIPE)/$(DEBIAN_PATCH_FILE))

ifeq ($(RECIPE_DEB_ARCH),arm64)
DEBIAN_ARCH_TRIPLET:=aarch64-linux-gnu
endif

DEBIAN_PACKAGES += apt-utils
DEBIAN_PACKAGES += kmod
DEBIAN_PACKAGES += pkg-config

QEMU_START:=cp /usr/bin/qemu-aarch64-static $(ROOTFS)/usr/bin
QEMU_DONE:=rm $(ROOTFS)/usr/bin/qemu-aarch64-static