LAYER:=debian-disable-login
include $(DEFINE_LAYER)

debian-disable-login:=$(LSTAMP)/debian-disable-login
disable-login.sh:=$(BUILD)/$(L)/disable-login.sh

$(L) += $(debian-disable-login)
$(L) += $(disable-login.sh)

include $(BUILD_LAYER)



$(debian-disable-login):
	$(QEMU_START)
	cp $(builddir)/disable-login.sh $(ROOTFS)/
	chmod +x $(ROOTFS)/disable-login.sh
	chroot $(ROOTFS) bash -c /disable-login.sh
	rm $(ROOTFS)/disable-login.sh
	$(QEMU_DONE)
	$(stamp)

$(debian-disable-login): $(disable-login.sh)


$(disable-login.sh):
	python3 $(DEBIAN_PATCH)/generate.py $(BASE_debian-disable-login)/scripts $(dir $(disable-login.sh)) $(DEBIAN_PATCH_CONFIG)


$(disable-login.sh): $(BASE_debian-disable-login)/scripts/disable-login.sh
