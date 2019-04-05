LAYER:=debian-minimise
include $(DEFINE_LAYER)

debian-minimise:=$(LSTAMP)/minimise

$(L) += $(debian-minimise)

DEPENDS += debian-packages

include $(BUILD_LAYER)

$(debian-minimise):
	rm -rf $(ROOTFS)/var/cache/apt
	rm -rf $(ROOTFS)/usr/share/doc
	rm -rf $(ROOTFS)/usr/share/man
	rm -rf $(ROOTFS)/usr/share/locale
	$(stamp)
