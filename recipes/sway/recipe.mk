include $(DEFINE_RECIPE)

SYSROOT:=$(OUT)/sysroot
MESON_OPTIONS:=

MESON_OPTIONS += --buildtype=release
SUDO?=sudo

#export CC=clang
#export CXX=clang++

DISTRO:=$(shell cat /etc/os-release | grep ^ID= | cut -d= -f2)
DISTRO_FULL:=$(DISTRO)

ifeq ($(DISTRO),ubuntu)
DISTRO_FULL:=$(DISTRO)-$(shell cat /etc/os-release | grep ^VERSION_ID= | cut -d= -f2)
endif

ifeq ($(DISTRO),arch)
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
WAYBAR_GIT_REF=master
endif

DEB_PACKAGES:=pkg-config cmake autoconf git
PIP_PACKAGES:=meson ninja

LAYERS += build-deps
LAYERS += drm
LAYERS += wayland
LAYERS += wayland-protocols
LAYERS += vulkan
LAYERS += mesa
LAYERS += xorgproto
LAYERS += libxcvt
LAYERS += xwayland

# LAYERS += scdoc
LAYERS += libseat
LAYERS += wlroots
LAYERS += sway
# LAYERS += greetd
#LAYERS += gtkgreet
# LAYERS += sway-systemd
# #LAYERS += remote-clip
LAYERS += swaylock-effects
LAYERS += swaylock
LAYERS += swayidle
LAYERS += swaybg
LAYERS += kanshi
LAYERS += mako

LAYERS += grim
LAYERS += slurp
LAYERS += wl-clipboard

LAYERS += pipewire
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

include $(BUILD_RECIPE)
