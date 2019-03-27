LAYER:=debian-os-patch
include $(DEFINE_LAYER)

include $(BASE)/layers/debian/config.mk

debian-os-patch:=$(LSTAMP)/debian-os-patch

$(L) += $(debian-os-patch)

DEPENDS += debian-debootstrap

include $(BUILD_LAYER)

DEBIAN_OS_PATCH_CONFIG:=$(call select_file,$(TOP)/config.json,$(RECIPE)/config.json)

$(debian-os-patch):
	python3 $(DEBIAN_PATCH)/generate.py $(BASE_debian-os-patch)/rootfs $(BUILD_debian-debootstrap)/rootfs $(DEBIAN_OS_PATCH_CONFIG)