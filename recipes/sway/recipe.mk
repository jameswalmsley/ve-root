include $(DEFINE_RECIPE)

DOCKER_IMAGE?=jameswalmsley/swaybuilder-ubuntu
DOCKER_SERVICE?=ubuntu-20.04

SYSROOT?=$(OUT)/sysroot
MESON_OPTIONS:=

MESON_OPTIONS += --buildtype=release --prefix=$(SYSROOT)/usr/local
CMAKE_OPTIONS += -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$(SYSROOT)/usr/local

SUDO?=sudo
CLANG:=clang-12
CLANG++:=clang++-12
MAKE:=make -j$(shell nproc)

DISTRO:=$(shell cat /etc/os-release | grep ^ID= | cut -d= -f2)
DISTRO_FULL:=$(DISTRO)

ifeq ($(DISTRO),ubuntu)
DISTRO_VER:=$(shell cat /etc/os-release | grep ^VERSION_ID= | cut -d= -f2)
DISTRO_VER:=$(shell echo $(DISTRO_VER))
DISTRO_FULL:=$(DISTRO)-$(DISTRO_VER)

CLANG:=clang-12
CLANG++:=clang++-12

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

LAYERS-y += build-deps
LAYERS-y += scdoc
LAYERS-y += libdrm
LAYERS-y += wayland
LAYERS-y += wayland-protocols
LAYERS-y += vulkan
LAYERS-y += mesa
LAYERS-y += xorgproto
LAYERS-y += libxcvt
LAYERS-y += libepoxy
LAYERS-y += libevdev
LAYERS-y += libinput
LAYERS-y += pixman
LAYERS-y += xwayland
LAYERS-y += libxkbcommon

LAYERS-y += libseat
LAYERS-y += wlroots
LAYERS-y += json-c
LAYERS-y += sway
LAYERS-y += sway-systemd

LAYERS-y += libva
LAYERS-y += ffmpeg

LAYERS-y += swaylock-effects
LAYERS-y += swayidle
LAYERS-y += swaybg
LAYERS-y += kanshi
LAYERS-y += mako

LAYERS-y += grim
LAYERS-y += slurp
LAYERS-y += wl-clipboard
LAYERS-y += swappy
# LAYERS-y += waypipe

LAYERS-$(CONFIG_LIBALSA) += libalsa
LAYERS-y += pipewire
LAYERS-$(CONFIG_LIBGEOCLUE) += geoclue
LAYERS-$(CONFIG_LIBFUSE) += libfuse
LAYERS-$(CONFIG_GLIB) += glib
LAYERS-y += gtk-layer-shell
LAYERS-y += libportal
LAYERS-y += xdg-desktop-portal
LAYERS-y += libinih
LAYERS-y += xdg-desktop-portal-wlr

LAYERS-y += waybar
LAYERS-y += wshowkeys
LAYERS-y += wf-recorder

LAYERS-y += mupdf
LAYERS-y += zathura
LAYERS-y += wlsunset

ifneq ($(DISTRO),arch)
	LAYERS-y += imv
endif

LAYERS-y += light
LAYERS-y += cxxopts
LAYERS-y += pamixer
LAYERS-y += avizo

LAYERS-y += sway-scripts

LAYERS-$(CONFIG_PACKAGE) += package

LAYERS += $(LAYERS-y)

include $(BUILD_RECIPE)


.PHONY:install
install: DESTDIR?=/
install:
	rm -rf $(OUT)/install-sysroot
	mkdir -p $(OUT)/install-sysroot
	cp -r $(SYSROOT)/* $(OUT)/install-sysroot
	find $(OUT)/install-sysroot -name "*.pc" | xargs sed -i "s,^prefix=.*,prefix=/usr/local,g"
	find $(OUT)/install-sysroot -name "*.pc" | xargs grep "^prefix="
	$(SUDO) rsync -avK --chown=root:root $(OUT)/install-sysroot/* $(DESTDIR)
