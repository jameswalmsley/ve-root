LAYER:=slurp
include $(DEFINE_LAYER)

SLURP_GIT_REF?=master

bdir:=slurp

slurp:=$(LSTAMP)/$(bdir)

$(L) += $(slurp)

$(call git_clone, $(bdir), https://github.com/emersion/slurp.git, $(SLURP_GIT_REF))

include $(BUILD_LAYER)

$(slurp): bdir:=$(bdir)
$(slurp):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
