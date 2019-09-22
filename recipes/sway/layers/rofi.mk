LAYER:=rofi
include $(DEFINE_LAYER)

bdir:=rofi

rofi:=$(LSTAMP)/$(bdir)

$(L) += $(rofi)

$(call git_clone, $(bdir), https://github.com/davatorium/rofi.git, master)

include $(BUILD_LAYER)

$(rofi): bdir:=$(bdir)
$(rofi):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja -v
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)


