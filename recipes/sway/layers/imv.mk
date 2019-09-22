LAYER:=imv
include $(DEFINE_LAYER)

bdir:=imv

imv:=$(LSTAMP)/$(bdir)

$(L) += $(imv)

$(call git_clone, $(bdir), https://github.com/eXeC64/imv.git, master)

include $(BUILD_LAYER)

$(imv): bdir:=$(bdir)
$(imv):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja -v
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)


