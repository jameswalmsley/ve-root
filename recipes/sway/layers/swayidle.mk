LAYER:=swayidle
include $(DEFINE_LAYER)

bdir:=swayidle

swayidle:=$(LSTAMP)/$(bdir)

$(L) += $(swayidle)

$(call git_clone, $(bdir), https://github.com/swaywm/swayidle.git, master)

include $(BUILD_LAYER)

$(swayidle): bdir:=$(bdir)
$(swayidle):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

