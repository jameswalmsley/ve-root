#
# Debian - debootstrap provision
#
LAYER:=debian-provision
include $(DEFINE_LAYER)

debian-provision:=$(LSTAMP)/provision

$(L) += $(debian-provision)

DEPENDS += debian-debootstrap

include $(BUILD_LAYER)

$(debian-provision):
	-rm -rf $(ROOTFS)
	mkdir -p $(ROOTFS)
	rsync -av $(BUILD_debian-debootstrap)/rootfs/* $(ROOTFS)/
	$(stamp)
