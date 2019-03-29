LAYER:=debian-full-upgrade
include $(DEFINE_LAYER)

debian-full-upgrade:=$(LSTAMP)/full-upgrade

$(L) += $(debian-full-upgrade)

include $(BUILD_LAYER)

$(debian-full-upgrade):
	$(QEMU_START)
	rsync -av $(basedir)/full-upgrade.sh $(ROOTFS)/full-upgrade.sh
	chroot $(ROOTFS) bash -c /full-upgrade.sh
	rm $(ROOTFS)/full-upgrade.sh
	$(QEMU_DONE)
	$(stamp)

$(debian-full-upgrade): $(BASE_debian-full-upgrade)/full-upgrade.sh
