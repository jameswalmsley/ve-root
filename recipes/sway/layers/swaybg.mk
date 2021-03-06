LAYER:=swaybg
include $(DEFINE_LAYER)

SWAYBG_GIT_REF?=master

bdir:=swaybg

swaybg:=$(LSTAMP)/$(bdir)

$(L) += $(swaybg)

$(call git_clone, $(bdir), https://github.com/swaywm/swaybg.git, $(SWAYBG_GIT_REF))

include $(BUILD_LAYER)

$(swaybg): bdir:=$(bdir)
$(swaybg):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)


