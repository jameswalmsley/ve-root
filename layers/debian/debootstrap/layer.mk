#
# Debian - Debootstrap Layer.
#
LAYER:=debian-debootstrap
include $(DEFINE_LAYER)

debian-debootstrap:=$(LSTAMP)/debootstrap
debian-debootstrap-provision:=$(LSTAMP)/provision

$(L) += $(debian-debootstrap)
$(L) += $(debian-debootstrap-provision)

include $(BUILD_LAYER)

$(debian-debootstrap):
	-rm -rf $(builddir)/rootfs
	debootstrap \
		--arch=$(RECIPE_DEB_ARCH) \
		--verbose \
		--foreign \
		--variant=minbase \
		$(RECIPE_DEB_RELEASE) \
		$(builddir)/rootfs
	cp /usr/bin/qemu-aarch64-static $(builddir)/rootfs/usr/bin
	chroot $(builddir)/rootfs /bin/bash -c "DEBIAN_FRONTEND=noninteractive /debootstrap/debootstrap --second-stage"
	rm -rf $(builddir)/rootfs/usr/bin/qemu-aarch64-static
	rm -rf $(builddir)/rootfs/debootstrap
	$(stamp)

$(debian-debootstrap-provision): $(debian-debootstrap)

$(debian-debootstrap-provision):
	-rm -rf $(ROOTFS)
	mkdir -p $(ROOTFS)
	rsync -av $(builddir)/rootfs/* $(ROOTFS)/
	$(stamp)
