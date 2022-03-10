LAYER:=mesa
include $(DEFINE_LAYER)

mesa_GIT_REF?=main

mesa:=$(LSTAMP)/mesa

$(L) += $(mesa)

DEB_PACKAGES += llvm-12
DEB_PACKAGES += libelf-dev
DEB_PACKAGES += bison
DEB_PACKAGES += byacc
DEB_PACKAGES += flex
DEB_PACKAGES += libx11-dev
DEB_PACKAGES += libxext-dev
DEB_PACKAGES += libxfixes-dev
DEB_PACKAGES += libxcb-glx0-dev
DEB_PACKAGES += libxcb-shm0-dev
DEB_PACKAGES += libx11-xcb-dev
DEB_PACKAGES += libxcb-dri2-0-dev
DEB_PACKAGES += libxcb-dri3-dev
DEB_PACKAGES += libxcb-present-dev
DEB_PACKAGES += libxshmfence-dev
DEB_PACKAGES += libxxf86vm-dev
DEB_PACKAGES += libxrandr-dev

PIP_PACKAGES += mako

DEPENDS += drm
DEPENDS += vulkan
DEPENDS += wayland
DEPENDS += wayland-protocols

$(call git_clone, mesa, https://gitlab.freedesktop.org/mesa/mesa.git, $(mesa_GIT_REF))

include $(BUILD_LAYER)

$(mesa):
	mkdir -p $(builddir)/mesa
	cd $(builddir)/mesa && meson $(MESON_OPTIONS) $(srcdir)/mesa $(builddir)/mesa -Ddri-drivers= -Dgallium-drivers=radeonsi,swrast,iris,zink -Dvulkan-drivers=intel,amd -Dgallium-nine=true -Dosmesa=false
	cd $(builddir)/mesa && ninja
	cd $(builddir)/mesa && DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/mesa && $(SUDO) ninja install && rm -rf $(builddir)/drm/meson-logs/install-log.txt
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/mesa

#
