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
	cd $(builddir)/wayland && $(srcdir)/wayland/autogen.sh --disable-documentation
	cd $(builddir)/wayland && make
	cd $(builddir)/wayland && sudo make install
	$(stamp)

