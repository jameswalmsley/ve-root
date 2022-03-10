LAYER:=wayland-protocols
include $(DEFINE_LAYER)

WAYLAND_PROTOCOLS_GIT_REF?=main

wayland-protocols:=$(LSTAMP)/wayland-protocols

$(L) += $(wayland-protocols)

DEPENDS += wayland

$(call git_clone, wayland-protocols, https://github.com/wayland-project/wayland-protocols.git, $(WAYLAND_PROTOCOLS_GIT_REF))

include $(BUILD_LAYER)

$(wayland-protocols):
	cd $(srcdir)/wayland-protocols && meson $(MESON_OPTIONS) $(builddir)
	cd $(builddir) && ninja && DESTDIR=$(SYSROOT) ninja install
	cd $(builddir) && ninja && $(SUDO) ninja install && rm -rf $(builddir)/wayland/meson-logs/install-log.txt
	$(stamp)

