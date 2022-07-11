include $(DEFINE_RECIPE)

DOCKER_IMAGE?=jameswalmsley/swaybuilder-ubuntu
DOCKER_SERVICE?=ubuntu-20.04

SYSROOT?=$(OUT)/sysroot
MESON_OPTIONS:=

MESON_OPTIONS += --buildtype=release --prefix=$(SYSROOT)/usr/local
CMAKE_OPTIONS += -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$(SYSROOT)/usr/local

SUDO?=sudo
CLANG:=clang-14
CLANG++:=clang++-14
MAKE:=make -j$(shell nproc)

DISTRO:=$(shell cat /etc/os-release | grep ^ID= | cut -d= -f2)
DISTRO_FULL:=$(DISTRO)

ifeq ($(DISTRO),ubuntu)
DISTRO_VER:=$(shell cat /etc/os-release | grep ^VERSION_ID= | cut -d= -f2)
DISTRO_VER:=$(shell echo $(DISTRO_VER))
DISTRO_FULL:=$(DISTRO)-$(DISTRO_VER)

CLANG:=clang-14
CLANG++:=clang++-14

CONFIG_LIBFUSE:=y

ifeq ($(DISTRO_VER),18.04)
	export CC=gcc-10
	export CXX=g++-10
	CONFIG_LIBALSA:=y
	CONFIG_LIBGEOCLUE:=y
	CONFIG_GLIB:=y
	avizo_GIT_REF:=1.0
	export CFLAGS:=-Wno-error=deprecated-declarations
endif

endif

# export PKG_CONFIG_SYSROOT_DIR=$(SYSROOT)
export PKG_CONFIG_PATH=$(SYSROOT)/usr/local/lib/pkgconfig:$(SYSROOT)/usr/local/lib64/pkgconfig:$(SYSROOT)/usr/local/lib/x86_64-linux-gnu/pkgconfig
export PREFIX=$(SYSROOT)/usr/local

pkg:
	echo $${PKG_CONFIG_PATH}
	echo $${PKG_CONFIG_SYSROOT_DIR}

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
# LAYERS += valgrind
LAYERS += mesa
LAYERS += xorgproto
LAYERS += libxcvt
LAYERS += libepoxy
LAYERS += libevdev
LAYERS += libinput
LAYERS += pixman
LAYERS += xwayland
LAYERS += libxkbcommon

LAYERS += libseat
LAYERS += wlroots
LAYERS += json-c
LAYERS += sway
LAYERS += sway-systemd

LAYERS += libva
LAYERS += ffmpeg

LAYERS += swaylock-effects
LAYERS += swayidle
LAYERS += swaybg
LAYERS += kanshi
LAYERS += mako

LAYERS += grim
LAYERS += slurp
LAYERS += wl-clipboard
LAYERS += swappy
# LAYERS += waypipe

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
LAYERS += wlsunset

ifneq ($(DISTRO),arch)
	LAYERS += imv
endif

LAYERS += light
LAYERS += cxxopts
LAYERS += pamixer
LAYERS += avizo

LAYERS += sway-scripts

LAYERS-$(CONFIG_PACKAGE) += package

LAYERS += $(LAYERS-y)

include $(BUILD_RECIPE)
