LAYER:=wob
include $(DEFINE_LAYER)

bdir:=wob

wob:=$(LSTAMP)/$(bdir)

$(L) += $(wob)

$(call git_clone, $(bdir), https://github.com/francma/wob.git, master)

include $(BUILD_LAYER)

$(wob): bdir:=$(bdir)
$(wob):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

