LAYER:=termite
include $(DEFINE_LAYER)

TERMITE_GIT_REF?=master

bdir:=$(LAYER)

termite:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += libgtk-3-dev

$(L) += $(termite)

$(call git_clone, $(bdir), https://github.com/thestinger/termite.git, $(TERMITE_GIT_REF))

DEPENDS += vte-ng

include $(BUILD_LAYER)

$(termite): bdir:=$(bdir)
$(termite):
	mkdir -p $(builddir)/$(bdir)
	cp -r $(srcdir)/$(bdir)/* $(builddir)/$(bdir)/
	sed -i 's/xterm-termite/xterm-256color/g' $(builddir)/$(bdir)/termite.cc
	cd $(builddir)/$(bdir) && $(MAKE) && sudo $(MAKE) install
	$(stamp)

