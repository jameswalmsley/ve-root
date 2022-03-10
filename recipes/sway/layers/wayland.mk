LAYER:=wayland
include $(DEFINE_LAYER)

WAYLAND_GIT_REF?=main

wayland:=$(LSTAMP)/wayland

DEB_PACKAGES += libffi-dev

$(L) += $(wayland)

$(call git_clone, wayland, https://github.com/wayland-project/wayland.git, $(WAYLAND_GIT_REF))

include $(BUILD_LAYER)

$(wayland):
	mkdir -p $(builddir)/wayland
	cd $(builddir)/wayland && meson $(MESON_OPTIONS) -Ddocumentation=false -Ddtd_validation=false -Dtests=false $(srcdir)/wayland $(builddir)/wayland
	cd $(builddir)/wayland && ninja
	cd $(builddir)/wayland && DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/wayland && $(SUDO) ninja install && rm -rf $(builddir)/wayland/meson-logs/install-log.txt
	$(stamp)

