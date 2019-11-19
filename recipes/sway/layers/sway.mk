LAYER:=sway
include $(DEFINE_LAYER)

SWAY_GIT_REF?=master

sway:=$(LSTAMP)/sway

$(L) += $(sway)

DEB_PACKAGES += libjson-c-dev
DEB_PACKAGES += libpango1.0-dev
DEB_PACKAGES += libgdk-pixbuf2.0-dev
DEB_PACKAGES += jq # Required for dmenu.sh integration.
DEB_PACKAGES += playerctl # Required for binding audio player buttons.
DEB_PACKAGES += qtwayland5

$(call git_clone, sway, https://github.com/swaywm/sway.git, $(SWAY_GIT_REF))

include $(BUILD_LAYER)

$(sway):
	mkdir -p $(builddir)/sway
	-cd $(srcdir)/sway && meson $(builddir)/sway --buildtype=release
	cd $(builddir)/sway && ninja
	cd $(builddir)/sway && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/sway
