LAYER:=wlroots
include $(DEFINE_LAYER)

WLROOTS_GIT_REF?=0.15.1

ifeq ($(CONFIG_SWAY_ROLLING),y)
WLROOTS_GIT_REF:=master
endif

wlroots:=$(LSTAMP)/wlroots

$(L) += $(wlroots)

DEPENDS += libseat

DEB_PACKAGES += libinput-dev
DEB_PACKAGES += libxkbcommon-dev
DEB_PACKAGES += libxcb-xinput-dev
DEB_PACKAGES += libxcb-res0-dev
DEB_PACKAGES += libxcb-icccm4-dev
DEB_PACKAGES += libsystemd-dev

$(call git_clone, wlroots, https://gitlab.freedesktop.org/wlroots/wlroots.git, $(WLROOTS_GIT_REF))

DEPENDS += xwayland
DEPENDS += libinput

include $(BUILD_LAYER)

$(wlroots):
	mkdir -p $(builddir)/wlroots
	cd $(builddir)/wlroots && meson $(MESON_OPTIONS) -Dexamples=false -Dxwayland=enabled $(srcdir)/wlroots $(builddir)/wlroots
	cd $(builddir)/wlroots && ninja
	cd $(builddir)/wlroots && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/wlroots && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/wlroots

