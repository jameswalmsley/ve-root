LAYER:=wayland-protocols
include $(DEFINE_LAYER)

WAYLAND_PROTOCOLS_GIT_REF?=1.25

wayland-protocols:=$(LSTAMP)/wayland-protocols

$(L) += $(wayland-protocols)

DEPENDS += wayland

$(call git_clone, wayland-protocols, https://github.com/wayland-project/wayland-protocols.git, $(WAYLAND_PROTOCOLS_GIT_REF))

include $(BUILD_LAYER)

$(wayland-protocols):
	cd $(srcdir)/wayland-protocols && meson $(MESON_OPTIONS) $(builddir)
	cd $(builddir) && ninja && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	cd $(builddir) && ninja && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

