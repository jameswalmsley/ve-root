LAYER:=wayland
include $(DEFINE_LAYER)

WAYLAND_GIT_REF?=master

wayland:=$(LSTAMP)/wayland

DEB_PACKAGES += libffi-dev
DEB_PACKAGES += libxml2-dev
DEB_PACKAGES += libtool

$(L) += $(wayland)

$(call git_clone, wayland, https://github.com/wayland-project/wayland.git, $(WAYLAND_GIT_REF))

include $(BUILD_LAYER)

$(wayland):
	mkdir -p $(builddir)/wayland
	cd $(builddir)/wayland && meson --buildtype=release -Ddocumentation=false $(srcdir)/wayland $(builddir)/wayland
	cd $(builddir)/wayland && ninja
	cd $(builddir)/wayland && sudo ninja install
	$(stamp)

