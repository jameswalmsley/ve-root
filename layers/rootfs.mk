#
# META/SYNC layer for entire rootfs
#

LAYER:=rootfs
include $(DEFINE_LAYER)

rootfs:=$(LSTAMP)/rootfs

$(L) += $(rootfs)

ROOTFS_DEPENDS_LIST:=$(LAYERS_INCLUDED)

DEPENDS += $(ROOTFS_DEPENDS_LIST)

include $(BUILD_LAYER)

$(rootfs):
	$(stamp)
