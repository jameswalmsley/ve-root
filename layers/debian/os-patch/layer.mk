LAYER:=debian-os-patch
include $(DEFINE_LAYER)

include $(BASE)/layers/debian/config.mk

debian-os-patch:=$(LSTAMP)/debian-os-patch

$(L) += $(debian-os-patch)

DEPENDS += debian-packages

include $(BUILD_LAYER)

$(debian-os-patch):
	python3 $(DEBIAN_PATCH)/generate.py $(BASE_debian-os-patch)/rootfs $(ROOTFS) $(DEBIAN_PATCH_CONFIG)
	$(stamp)

$(debian-os-patch): $(shell find $(BASE_debian-os-patch)/rootfs -type f)

$(debian-os-patch): $(DEBIAN_OS_PATCH_CONFIG)
