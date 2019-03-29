LAYER:=debian-configure
include $(DEFINE_LAYER)

debian-configure:=$(LSTAMP)/configure

$(L) += $(debian-configure)

DEPENDS += debian-provision

include $(BUILD_LAYER)

DEBIAN_CONFIG:=$(call select_file,$(TOP)/config.json,$(RECIPE)/config.json)

$(debian-configure):
	python3 $(DEBIAN_PATCH)/generate.py $(BASE_debian-configure)/rootfs $(ROOTFS) $(DEBIAN_CONFIG)
	$(QEMU_START)
	chmod +x $(ROOTFS)/users.sh
	chroot $(ROOTFS) bash -c /users.sh
	rm $(ROOTFS)/users.sh
ifneq ($(wildcard $(RECIPE)/scripts/configure.sh),)	
	rsync -av $(RECIPE)/scripts/configure.sh $(ROOTFS)/configure.sh
	chroot $(ROOTFS) bash -c /configure.sh
	rm $(ROOTFS)/configure.sh
endif
ifneq ($(wildcard $(TOP)/scripts/configure.sh),)
	rsync -av $(TOP)/scripts/configure.sh $(ROOTFS)/configure.sh
	chroot $(ROOTFS) bash -c /configure.sh
	rm $(ROOTFS)/configure.sh
endif
	$(QEMU_DONE)
	$(stamp)