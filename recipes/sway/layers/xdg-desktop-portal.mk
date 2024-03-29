LAYER:=xdg-desktop-portal
include $(DEFINE_LAYER)

xdg-desktop-portal_GIT_REF?=main

xdg-desktop-portal:=$(LSTAMP)/xdg-desktop-portal

$(L) += $(xdg-desktop-portal)

DEB_PACKAGES += libtool
DEB_PACKAGES += libsystemd-dev
DEB_PACKAGES += libjson-glib-dev
DEB_PACKAGES += libgeoclue-2-dev

DEPENDS += pipewire
DEPENDS += geoclue
DEPENDS += libfuse

$(call git_clone, xdg-desktop-portal, https://github.com/flatpak/xdg-desktop-portal.git, $(xdg-desktop-portal_GIT_REF))

include $(BUILD_LAYER)

$(xdg-desktop-portal):
	mkdir -p $(builddir)/xdg-desktop-portal
	cd $(builddir)/xdg-desktop-portal && $(srcdir)/xdg-desktop-portal/autogen.sh --prefix=$(SYSROOT)/usr/local
	cd $(builddir)/xdg-desktop-portal && $(MAKE)
	cd $(builddir)/xdg-desktop-portal && $(SUDO) $(MAKE) install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/xdg-desktop-portal

