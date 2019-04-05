#
# Debian - Debootstrap Layer.
#
LAYER:=debian-debootstrap
include $(DEFINE_LAYER)

debian-debootstrap:=$(LSTAMP)/debootstrap

$(L) += $(debian-debootstrap)

include $(BUILD_LAYER)

$(debian-debootstrap):
	-rm -rf $(builddir)/rootfs
	debootstrap \
		--arch=$(RECIPE_DEB_ARCH) \
		--verbose \
		--foreign \
		--variant=minbase \
		--include=$(subst $(space),$(comma),$(strip $(DEBIAN_PACKAGES))) \
		$(RECIPE_DEB_RELEASE) \
		$(builddir)/rootfs
	cp /usr/bin/qemu-aarch64-static $(builddir)/rootfs/usr/bin
	chroot $(builddir)/rootfs /bin/bash -c "DEBIAN_FRONTEND=noninteractive /debootstrap/debootstrap --second-stage"
	rm -rf $(builddir)/rootfs/usr/bin/qemu-aarch64-static
	rm -rf $(builddir)/rootfs/debootstrap
	$(stamp)

