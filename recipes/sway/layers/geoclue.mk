LAYER:=geoclue
include $(DEFINE_LAYER)

geoclue_GIT_REF?=master

geoclue:=$(LSTAMP)/geoclue

$(L) += $(geoclue)

DEB_PACKAGES += libjson-glib-dev
DEB_PACKAGES += libsoup2.4-dev
DEB_PACKAGES += libmm-glib-dev
DEB_PACKAGES += libavahi-client-dev
DEB_PACKAGES += libavahi-glib-dev
DEB_PACKAGES += libnotify-dev

$(call git_clone, geoclue, https://gitlab.freedesktop.org/geoclue/geoclue.git, $(geoclue_GIT_REF))

DEPENDS += glib

include $(BUILD_LAYER)

$(geoclue):
	mkdir -p $(builddir)/geoclue
	cd $(builddir)/geoclue && meson $(srcdir)/geoclue $(builddir)/geoclue $(MESON_OPTIONS) -Dgtk-doc=false
	cd $(builddir)/geoclue && ninja
	cd $(builddir)/geoclue && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/geoclue


