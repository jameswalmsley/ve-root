LAYER:=termite
include $(DEFINE_LAYER)

bdir:=$(LAYER)

termite:=$(LSTAMP)/$(bdir)

$(L) += $(termite)

$(call git_clone, $(bdir), https://github.com/thestinger/termite.git, master)

DEB_PACKAGES += libpcre2-dev

include $(BUILD_LAYER)

$(termite): bdir:=$(bdir)
$(termite):
	mkdir -p $(builddir)/$(bdir)
	cp -r $(srcdir)/$(bdir)/* $(builddir)/$(bdir)/
	sed -i 's/xterm-termite/xterm-256color/g' $(builddir)/$(bdir)/termite.cc
	cd $(builddir)/$(bdir) && $(MAKE) && sudo $(MAKE) install
	$(stamp)

