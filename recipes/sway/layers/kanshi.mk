LAYER:=kanshi
include $(DEFINE_LAYER)

bdir:=$(LAYER)

kanshi:=$(LSTAMP)/$(bdir)

$(L) += $(kanshi)

$(call git_clone, $(bdir), https://github.com/emersion/kanshi.git, master)

include $(BUILD_LAYER)

$(kanshi): bdir:=$(bdir)
$(kanshi):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
