#
# META/SYNC layer for entire rootfs
#

LAYER:=rootfs
include $(DEFINE_LAYER)

rootfs:=$(LSTAMP)/rootfs

$(L) += $(rootfs)

DEPENDS += debian-provision
DEPENDS += debian-packages
DEPENDS += debian-full-upgrade
DEPENDS += debian-os-patch
DEPENDS += debian-customise
DEPENDS += rootfs-permissions
DEPENDS += debian-configure
DEPENDS += debian-minimise
DEPENDS += debian-depmod
DEPENDS += rpi-firmware

include $(BUILD_LAYER)

$(rootfs):
	$(stamp)

