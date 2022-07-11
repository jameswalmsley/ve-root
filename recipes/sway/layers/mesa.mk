LAYER:=mesa
include $(DEFINE_LAYER)

mesa_GIT_REF?=mesa-22.0.0

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
DEB_PACKAGES += libvdpau-dev
DEB_PACKAGES += libclc-dev
DEB_PACKAGES += libsensors4-dev
DEB_PACKAGES += libclang-12-dev

PIP_PACKAGES += mako

DEPENDS += libdrm
DEPENDS += vulkan
DEPENDS += wayland
DEPENDS += wayland-protocols

export PATH:=/usr/lib/llvm-12/bin/:$(PATH)

$(call git_clone, mesa, https://gitlab.freedesktop.org/mesa/mesa.git, $(mesa_GIT_REF))

include $(BUILD_LAYER)

MESA_CFLAGS += -Wall -O2
MESA_CXXFLAGS += -Wall -O2

VULKAN_DRIVERS += intel amd swrast
DRI_DRIVERS += nouveau i915 i965
GALLIUM_DRIVERS += nouveau virgl svga d3d12 zink

EGL_PLATFORMS:=x11

MESA_OPTIONS += -Dglx-direct=true
MESA_OPTIONS += -Dgbm=enabled
MESA_OPTIONS += -Dgallium-extra-hud=true
MESA_OPTIONS += -Dgallium-vdpau=enabled
MESA_OPTIONS += -Dgallium-xa=enabled
MESA_OPTIONS += -Dlmsensors=enabled

MESA_OPTIONS += -Ddri3=enabled
MESA_OPTIONS += -Dllvm=enabled
MESA_OPTIONS += -Dgallium-opencl=icd
MESA_OPTIONS += -Dgallium-nine=true
MESA_OPTIONS += -Dvulkan-layers="device-select, overlay"

EGL_PLATFORMS += ,wayland

empty:=
space := $(empty) $(empty)
comma := ,
DRI_DRIVERS := $(patsubst %,'%',$(DRI_DRIVERS))
DRI_DRIVERS_LIST := $(subst $(space),$(comma),$(DRI_DRIVERS))
GALLIUM_DRIVERS := $(patsubst %,'%',$(GALLIUM_DRIVERS))
GALLIUM_DRIVERS_LIST := $(subst $(space),$(comma),$(GALLIUM_DRIVERS))
VULKAN_DRIVERS := $(patsubst %,'%',$(VULKAN_DRIVERS))
VULKAN_DRIVERS_LIST := $(subst $(space),$(comma),$(VULKAN_DRIVERS))

confflags_EGL = -Dplatforms="$(EGL_PLATFORMS)"
confflags_GLES = -Dgles1=disabled -Dgles2=enabled
confflags_GALLIUM += -Dgallium-drivers="[$(GALLIUM_DRIVERS_LIST)]"

MESA_FLAGS += \
	-Ddri-drivers="[$(DRI_DRIVERS_LIST)]" \
	-Ddri-drivers-path=/usr/lib/$(DEB_HOST_MULTIARCH)/dri \
	-Ddri-search-path='/usr/lib/$(DEB_HOST_MULTIARCH)/dri:\$$$${ORIGIN}/dri:/usr/lib/dri' \
	-Dvulkan-drivers="[$(VULKAN_DRIVERS_LIST)]" \
	-Dglvnd=true \
	-Dshared-glapi=enabled \
	-Dgallium-xvmc=disabled \
	-Dgallium-omx=disabled \
	-Db_ndebug=true \
	-Dbuild-tests=false \
	-Dvalgrind=false \
	$(MESA_OPTIONS)

$(mesa):
	mkdir -p $(builddir)/mesa
	@echo $(MESA_FLAGS)
	cd $(builddir)/mesa && CFLAGS="$(MESA_CFLAGS)" CXXFLAGS="$(MESA_CXXFLAGS)" meson $(MESON_OPTIONS) $(srcdir)/mesa $(builddir)/mesa $(MESA_OPTIONS)
	cd $(builddir)/mesa && ninja
	cd $(builddir)/mesa && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/mesa

#
