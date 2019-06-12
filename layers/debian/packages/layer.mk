LAYER:=debian-packages
include $(DEFINE_LAYER)

debian-configure-apt:=$(LSTAMP)/configure-apt
debian-install-packages:=$(LSTAMP)/install-packages

$(L) += $(debian-configure-apt)
$(L) += $(debian-install-packages)

DEPENDS += debian-provision

include $(BUILD_LAYER)

$(debian-configure-apt):
	python3 $(DEBIAN_PATCH)/generate.py $(BASE_debian-packages)/rootfs $(ROOTFS) $(DEBIAN_PATCH_CONFIG)
	$(stamp)

$(debian-configure-apt): $(shell find $(BASE_debian-packages)/rootfs -type f)

$(debian-install-packages):
	$(QEMU_START)
	rsync -av $(basedir)/scripts/install-packages.sh $(ROOTFS)/install-packages.sh
ifneq ($(wildcard $(ROOTFS)/packages.list),)
	rm $(ROOTFS)/packages.list
endif
ifneq ($(wildcard $(RECIPE)/packages.list),)
	cat $(RECIPE)/packages.list >> $(ROOTFS)/packages.list
endif
ifneq ($(wildcard $(RECIPE)/dev-packages.list),)
	(echo) >> $(ROOTFS)/packages.list
	cat $(RECIPE)/dev-packages.list >> $(ROOTFS)/packages.list
endif
ifneq ($(TOP),$(RECIPE))
ifneq ($(wildcard $(TOP)/packages.list),)
	(echo) >> $(ROOTFS)/packages.list
	cat $(TOP)/packages.list >> $(ROOTFS)/packages.list
endif
ifneq ($(wildcard $(TOP)/dev-packages.list),)
	(echo) >> $(ROOTFS)/packages.list
	cat $(TOP)/dev-packages.list >> $(ROOTFS)/packages.list
endif
endif
	chroot $(ROOTFS) bash -c /install-packages.sh
	-rm $(ROOTFS)/packages.list
	-rm $(ROOTFS)/install-packages.sh
	$(QEMU_DONE)
	$(stamp)

$(debian-install-packages): $(BASE_debian-packages)/scripts/install-packages.sh
$(debian-install-packages): | $(debian-full-upgrade)

ifneq ($(wildcard $(RECIPE)/packages.list),)
$(debian-install-packages): $(RECIPE)/packages.list
endif

ifneq ($(wildcard $(RECIPE)/dev-packages.list),)
$(debian-install-packages): $(RECIPE)/dev-packages.list
endif

ifneq ($(wildcard $(TOP)/packages.list),)
$(debian-install-packages): $(TOP)/packages.list
endif

ifneq ($(wildcard $(TOP)/dev-packages.list),)
$(debian-install-packages): $(TOP)/dev-packages.list
endif

ifneq ($(wildcard $(TOP)/packages.list),)
$(debian-install-packages): $(TOP)/packages.list
endif
