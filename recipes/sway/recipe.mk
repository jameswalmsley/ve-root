include $(DEFINE_RECIPE)

SYSROOT:=$(OUT)/sysroot
MESON_OPTIONS:=

MESON_OPTIONS += --buildtype=release
SUDO?=sudo
CLANG:=clang
CLANG++:=clang++
MAKE:=make -j$(shell nproc)

DISTRO:=$(shell cat /etc/os-release | grep ^ID= | cut -d= -f2)
DISTRO_FULL:=$(DISTRO)

ifeq ($(DISTRO),ubuntu)
DISTRO_VER:=$(shell cat /etc/os-release | grep ^VERSION_ID= | cut -d= -f2)
DISTRO_VER:=$(shell echo $(DISTRO_VER))
DISTRO_FULL:=$(DISTRO)

CLANG:=clang-12
CLANG++:=clang++-12

ifeq ($(DISTRO_VER),18.04)
	export CC=gcc-10
	export CXX=g++-10
	CONFIG_LIBALSA:=y
	CONFIG_LIBFUSE:=y
	CONFIG_LIBGEOCLUE:=y
	CONFIG_GLIB:=y
	export CFLAGS:=-Wno-error=deprecated-declarations
endif

endif

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/local/lib/x86-_64-linux-gnu/pkgconfig

ifeq ($(DISTRO),arch)
WAYBAR_GIT_REF=master
endif

DEB_PACKAGES:=pkg-config cmake autoconf git
PIP_PACKAGES:=meson ninja

LAYERS += build-deps
LAYERS += scdoc
LAYERS += libdrm
LAYERS += wayland
LAYERS += wayland-protocols
LAYERS += vulkan
LAYERS += mesa
LAYERS += xorgproto
LAYERS += libxcvt
LAYERS += libepoxy
LAYERS += libinput
LAYERS += xwayland

LAYERS += libseat
LAYERS += wlroots
LAYERS += json-c
LAYERS += sway

# LAYERS += greetd
# LAYERS += gtkgreet
# LAYERS += sway-systemd
LAYERS += swaylock-effects
LAYERS += swayidle
LAYERS += swaybg
LAYERS += kanshi
LAYERS += mako

LAYERS += grim
LAYERS += slurp
LAYERS += wl-clipboard

LAYERS-$(CONFIG_LIBALSA) += libalsa
LAYERS += pipewire
LAYERS-$(CONFIG_LIBGEOCLUE) += geoclue
LAYERS-$(CONFIG_LIBFUSE) += libfuse
LAYERS-$(CONFIG_GLIB) += glib
LAYERS += gtk-layer-shell
LAYERS += libportal
LAYERS += xdg-desktop-portal
LAYERS += libinih
LAYERS += xdg-desktop-portal-wlr

LAYERS += waybar
LAYERS += wshowkeys
LAYERS += wf-recorder

LAYERS += mupdf
LAYERS += zathura
LAYERS += redshift

ifneq ($(DISTRO),arch)
	LAYERS += imv
endif

LAYERS += light
LAYERS += cxxopts
LAYERS += pamixer
LAYERS += avizo

LAYERS += package

LAYERS += $(LAYERS-y)

include $(BUILD_RECIPE)
