LAYER:=imv
include $(DEFINE_LAYER)

bdir:=imv

imv:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += libfreeimage-dev
DEB_PACKAGES += libcmocka-dev libjpeg-dev libtiff-dev
DEB_PACKAGES += libxkbcommon-x11-dev

$(L) += $(imv)

$(call git_clone, $(bdir), https://git.sr.ht/~exec64/imv, master)

include $(BUILD_LAYER)

$(imv): bdir:=$(bdir)
$(imv):
	mkdir -p $(builddir)/imv
	cd $(srcdir)/imv && meson $(builddir)/imv $(MESON_OPTIONS)
	cd $(builddir)/imv && ninja
	cd $(builddir)/imv && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)


