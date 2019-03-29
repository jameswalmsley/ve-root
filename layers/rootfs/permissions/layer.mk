LAYER:=rootfs-permissions
include $(DEFINE_LAYER)

rootfs-permissions:=$(LSTAMP)/permissions

$(L) += $(rootfs-permissions)

DEPENDS += debian-customise

include $(BUILD_LAYER)


$(rootfs-permissions):
	$(QEMU_START)
	cp $(RECIPE)/permissions.list $(ROOTFS)/permissions.list
	rsync -av $(basedir)/permissions.sh $(ROOTFS)/permissions.sh
	chroot $(ROOTFS) bash -c /permissions.sh
ifneq ($(wildcard $(TOP)/permissions.list),)
	cp $(TOP)/permissions.list $(ROOTFS)/permissions.list
	chroot $(ROOTFS) bash -c /permissions.sh
endif
	$(QEMU_DONE)
	rm $(ROOTFS)/permissions.list
	rm $(ROOTFS)/permissions.sh
	$(stamp)

$(rootfs-permissions): $(RECIPE)/permissions.list

ifneq ($(wildcard $(TOP)/permissions.list),)
$(rootfs-permissions): $(TOP)/permissions.list
endif
