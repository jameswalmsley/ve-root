LAYER:=waypipe
include $(DEFINE_LAYER)

waypipe_GIT_REF?=master

waypipe:=$(LSTAMP)/waypipe

$(L) += $(waypipe)

$(call git_clone, waypipe, https://gitlab.freedesktop.org/mstoeckl/waypipe.git, $(waypipe_GIT_REF))

DEB_PACKAGES += liblz4-dev
DEB_PACKAGES += libzstd-dev
DEB_PACKAGES += libavcodec-dev
DEB_PACKAGES += libavutil-dev
DEB_PACKAGES += libswscale-dev
DEB_PACKAGES += libva-dev

DEPENDS += sway

include $(BUILD_LAYER)

$(waypipe):
$(waypipe):
	mkdir -p $(builddir)/waypipe
	cd $(srcdir)/waypipe && meson $(MESON_OPTIONS) $(srcdir)/waypipe $(builddir)/waypipe
	cd $(builddir)/waypipe && ninja
	cd $(builddir)/waypipe && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/waypipe



