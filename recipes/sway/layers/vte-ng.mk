LAYER:=vte-ng
include $(DEFINE_LAYER)

bdir:=$(LAYER)

vte-ng:=$(LSTAMP)/$(bdir)

$(L) += $(vte-ng)

$(call git_clone, $(bdir), https://github.com/thestinger/vte-ng.git, 0.50.2-ng)

include $(BUILD_LAYER)

$(vte-ng): bdir:=$(bdir)
$(vte-ng):
	mkdir -p $(builddir)/$(bdir)
	rsync -av --exclude=.git $(srcdir)/$(bdir) $(builddir)/
	cd $(builddir)/$(bdir) && ./autogen.sh --disable-introspection --disable-vala
	#cd $(builddir)/$(bdir) && ./configure
	cd $(builddir)/$(bdir) && $(MAKE) && sudo $(MAKE) install
	$(stamp)

