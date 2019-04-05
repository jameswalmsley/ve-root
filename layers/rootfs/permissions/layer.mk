LAYER:=rootfs-permissions
include $(DEFINE_LAYER)

rootfs-permissions:=$(LSTAMP)/permissions

$(L) += $(rootfs-permissions)

DEPENDS += debian-customise

include $(BUILD_LAYER)


$(rootfs-permissions):
	$(QEMU_START)
	touch $(ROOTFS)/permissions.list
ifneq ($(wildcard $(RECIPE)/permissions.list),)
	cat $(RECIPE)/permissions.list >> $(ROOTFS)/permissions.list
endif
ifneq ($(wildcard $(TOP)/permissions.list),)
	cat $(TOP)/permissions.list >> $(ROOTFS)/permissions.list
endif
	rsync -av $(basedir)/permissions.sh $(ROOTFS)/permissions.sh
	chroot $(ROOTFS) bash -c /permissions.sh
	$(QEMU_DONE)
	rm $(ROOTFS)/permissions.list
	rm $(ROOTFS)/permissions.sh
	$(stamp)

ifneq ($(wildcard $(RECIPE)/permissions.list),)
$(rootfs-permissions): $(RECIPE)/permissions.list
endif

ifneq ($(wildcard $(TOP)/permissions.list),)
$(rootfs-permissions): $(TOP)/permissions.list
endif

$(rootfs-permissions): $(BASE_rootfs-permissions)/permissions.sh