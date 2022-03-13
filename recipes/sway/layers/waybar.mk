LAYER:=waybar
include $(DEFINE_LAYER)

WAYBAR_GIT_REF?=0.9.7

waybar:=$(LSTAMP)/waybar

DEB_PACKAGES += libgtkmm-3.0-dev
DEB_PACKAGES += libjsoncpp-dev
DEB_PACKAGES += libpulse-dev
DEB_PACKAGES += libdbusmenu-gtk3-dev
DEB_PACKAGES += libnl-3-dev
DEB_PACKAGES += libnl-genl-3-dev
DEB_PACKAGES += pavucontrol
DEB_PACKAGES += libinput-dev
DEB_PACKAGES += libsigc++-2.0-dev
DEB_PACKAGES += libfmt-dev
DEB_PACKAGES += libmpdclient-dev
DEB_PACKAGES += libgtk-3-dev
DEB_PACKAGES += gobject-introspection
DEB_PACKAGES += libgirepository1.0-dev

DEB_RUN_PACKAGES += libjsoncpp1
DEB_RUN_PACKAGES += libmpdclient2

$(L) += $(waybar)

$(call git_clone, waybar, https://github.com/Alexays/Waybar.git, $(WAYBAR_GIT_REF))

include $(BUILD_LAYER)

$(waybar):
	mkdir -p $(builddir)/waybar
	cd $(srcdir)/waybar && CXX=$(CLANG++) meson $(builddir)/waybar $(MESON_OPTIONS) -Ddbusmenu-gtk=enabled
	cd $(builddir)/waybar && ninja
	cd $(builddir)/waybar && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
