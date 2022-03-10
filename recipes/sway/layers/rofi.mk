LAYER:=rofi
include $(DEFINE_LAYER)

ROFI_GIT_REF?=master

bdir:=rofi

rofi:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += librsvg2-dev
DEB_PACKAGES += libxkbcommon-x11-dev
DEB_PACKAGES += libxcb-util-dev
DEB_PACKAGES += libxcb-ewmh-dev
DEB_PACKAGES += libxcb-xrm-dev
DEB_PACKAGES += libxcb-xinerama0-dev
DEB_PACKAGES += libstartup-notification0-dev
DEB_PACKAGES += flex
DEB_PACKAGES += bison

$(L) += $(rofi)

$(call git_clone, $(bdir), https://github.com/davatorium/rofi.git, $(ROFI_GIT_REF))

include $(BUILD_LAYER)

$(rofi): bdir:=$(bdir)
$(rofi):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)



