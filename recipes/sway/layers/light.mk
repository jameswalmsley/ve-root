LAYER:=light
include $(DEFINE_LAYER)

bdir:=$(LAYER)

light:=$(LSTAMP)/$(bdir)

$(L) += $(light)

$(call git_clone, $(bdir), https://github.com/haikarainen/light.git ,master)

include $(BUILD_LAYER)

$(light): bdir:=$(bdir)
$(light):
	mkdir -p $(builddir)/$(bdir)
	cp -r $(srcdir)/$(bdir) $(builddir)/
	cd $(builddir)/$(bdir) && ./autogen.sh
	cd $(builddir)/$(bdir) && ./configure
	cd $(builddir)/$(bdir) && $(MAKE) && sudo $(MAKE) install
	$(stamp)

