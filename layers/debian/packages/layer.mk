LAYER:=debian-packages
include $(DEFINE_LAYER)

debian-full-upgrade:=$(LSTAMP)/full-upgrade
debian-install-packages:=$(LSTAMP)/install-packages

$(L) += $(debian-full-upgrade)

DEPENDS += debian-os-patch

include $(BUILD_LAYER)

$(debian-full-upgrade):
	$(QEMU_START)
	rsync -av $(basedir)/scripts/full-upgrade.sh $(ROOTFS)/full-upgrade.sh
	chroot $(ROOTFS) bash -c /full-upgrade.sh
	rm $(ROOTFS)/full-upgrade.sh
	$(QEMU_DONE)
	$(stamp)

$(debian-full-upgrade): $(BASE_debian-packages)/scripts/full-upgrade.sh
