#
# META/SYNC layer for entire rootfs
#

LAYER:=rootfs
include $(DEFINE_LAYER)

rootfs:=$(LSTAMP)/rootfs

$(L) += $(rootfs)

DEPENDS += debian-minimise
DEPENDS += debian-customise

include $(BUILD_LAYER)

$(rootfs):
	$(stamp)