LAYER:=waybar
include $(DEFINE_LAYER)

WAYBAR_GIT_REF?=master

waybar:=$(LSTAMP)/waybar

DEB_PACKAGES += libgtkmm-3.0-dev
DEB_PACKAGES += libjsoncpp-dev
DEB_PACKAGES += libpulse-dev
DEB_PACKAGES += libdbusmenu-gtk3-dev
DEB_PACKAGES += libnl-3-dev
DEB_PACKAGES += libnl-genl-3-dev
DEB_PACKAGES += pavucontrol
DEB_PACKAGES += libinput-dev libsigc++-2.0-dev libfmt-dev clang-tidy libmpdclient-dev libwayland-dev libgtk-3-dev gobject-introspection libgirepository1.0-dev

$(L) += $(waybar)

$(call git_clone, waybar, https://github.com/Alexays/Waybar.git, $(WAYBAR_GIT_REF))

include $(BUILD_LAYER)

$(waybar):
	mkdir -p $(builddir)/waybar
	cd $(srcdir)/waybar && CXX=clang++ meson $(builddir)/waybar --buildtype=release -Ddbusmenu-gtk=enabled
	cd $(builddir)/waybar && ninja
	cd $(builddir)/waybar && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
