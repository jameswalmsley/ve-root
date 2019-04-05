LAYER:=rootfs-configure
include $(DEFINE_LAYER)

rootfs-configure:=$(LSTAMP)/rootfs-configure

$(L) += $(rootfs-configure)

include $(BUILD_LAYER)

$(rootfs-configure):
	$(QEMU_START)
	cp $(RECIPE)/configure.sh $(ROOTFS)/configure.sh
	chmod +x $(ROOTFS)/configure.sh
	chroot $(ROOTFS) bash -c /configure.sh
	$(QEMU_DONE)
	rm -f $(ROOTFS)/configure.sh
	$(stamp)


$(rootfs-configure): $(RECIPE)/configure.sh
