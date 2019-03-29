LAYER:=debian-packages
include $(DEFINE_LAYER)

debian-install-packages:=$(LSTAMP)/install-packages

$(L) += $(debian-install-packages)

DEPENDS += debian-provision

include $(BUILD_LAYER)

$(debian-install-packages):
	$(QEMU_START)
	rsync -av $(basedir)/scripts/install-packages.sh $(ROOTFS)/install-packages.sh
	rsync -av $(RECIPE)/packages.list $(ROOTFS)/packages.list
ifneq ($(wildcard $(TOP)/packages.list),)
	cat $(TOP)/packages.list >> $(ROOTFS)/packages.list
endif
	chroot $(ROOTFS) bash -c /install-packages.sh
	rm $(ROOTFS)/packages.list $(ROOTFS)/install-packages.sh
	$(QEMU_DONE)
	$(stamp)

$(debian-install-packages): $(BASE_debian-packages)/scripts/install-packages.sh
$(debian-install-packages): | $(debian-full-upgrade)
$(debian-install-packages): $(RECIPE)/packages.list

ifneq ($(wildcard $(TOP)/packages.list),)
$(debian-install-packages): $(TOP)/packages.list
endif
