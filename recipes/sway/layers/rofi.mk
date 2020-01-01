LAYER:=rofi
include $(DEFINE_LAYER)

bdir:=rofi

rofi:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += librsvg2-dev
DEB_PACKAGES += libxkbcommon-x11-dev
DEB_PACKAGES += libstartup-notification0-dev
DEB_PACKAGES += flex
DEB_PACKAGES += bison

$(L) += $(rofi)

$(call git_clone, $(bdir), https://github.com/davatorium/rofi.git, master)

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



