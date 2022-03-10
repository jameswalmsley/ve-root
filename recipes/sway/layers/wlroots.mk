LAYER:=wlroots
include $(DEFINE_LAYER)

WLROOTS_GIT_REF?=master

wlroots:=$(LSTAMP)/wlroots

$(L) += $(wlroots)

DEB_PACKAGES += libinput-dev
DEB_PACKAGES += libxkbcommon-dev
DEB_PACKAGES += libxcb-xinput-dev
DEB_PACKAGES += libsystemd-dev
DEB_PACKAGES += libcap-dev
#DEB_PACKAGES += libxcberrors-dev
DEB_PACKAGES += libxcb-icccm4-dev
DEB_PACKAGES += libavutil-dev
DEB_PACKAGES += libavcodec-dev
DEB_PACKAGES += libavformat-dev

$(call git_clone, wlroots, https://gitlab.freedesktop.org/wlroots/wlroots.git, $(WLROOTS_GIT_REF))

include $(BUILD_LAYER)

$(wlroots):
	mkdir -p $(builddir)/wlroots
	cd $(builddir)/wlroots && meson --buildtype=release -Dxwayland=enabled $(srcdir)/wlroots $(builddir)/wlroots
	cd $(builddir)/wlroots && ninja
	cd $(builddir)/wlroots && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/wlroots

