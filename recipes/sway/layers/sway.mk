LAYER:=sway
include $(DEFINE_LAYER)

SWAY_GIT_REF?=1.7-ve-root

sway:=$(LSTAMP)/sway

DEB_PACKAGES += libjson-c-dev
DEB_PACKAGES += libpango1.0-dev
DEB_PACKAGES += libgdk-pixbuf2.0-dev

$(L) += $(sway)

DEPENDS += wlroots
DEPENDS += json-c

ifeq ($(CONFIG_SWAY_ROLLING),y)
$(call git_clone, sway, https://github.com/swaywm/sway.git, master)
else
$(call git_clone, sway, https://github.com/jameswalmsley/sway.git, $(SWAY_GIT_REF))
endif

include $(BUILD_LAYER)

$(sway):
	mkdir -p $(builddir)/sway
	-cd $(srcdir)/sway && meson $(builddir)/sway $(MESON_OPTIONS)
	cd $(builddir)/sway && ninja
	cd $(builddir)/sway && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/sway
