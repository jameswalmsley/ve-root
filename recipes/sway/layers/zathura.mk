LAYER:=zathura
include $(DEFINE_LAYER)

bdir:=zathura

zathura:=$(LSTAMP)/$(bdir)

$(L) += $(zathura)

$(call git_clone, $(bdir), https://git.pwmt.org/pwmt/zathura.git, master)

include $(BUILD_LAYER)

$(zathura): bdir:=$(bdir)
$(zathura):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja -v
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)


