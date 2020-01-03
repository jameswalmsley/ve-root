LAYER:=imv
include $(DEFINE_LAYER)

bdir:=imv

imv:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += libfreeimage-dev
DEB_PACKAGES += asciidoc-base

$(L) += $(imv)

$(call git_clone, $(bdir), https://github.com/eXeC64/imv.git, master)

include $(BUILD_LAYER)

$(imv): bdir:=$(bdir)
$(imv):
	mkdir -p $(builddir)/$(bdir)
	rsync -av --delete $(srcdir)/$(bdir) $(builddir)
	cd $(builddir)/$(bdir) && $(MAKE) && sudo $(MAKE) install
	$(stamp)


