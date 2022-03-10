LAYER:=light
include $(DEFINE_LAYER)

LIGHT_GIT_REF?=master

bdir:=$(LAYER)

light:=$(LSTAMP)/$(bdir)

$(L) += $(light)

$(call git_clone, $(bdir), https://github.com/haikarainen/light.git, $(LIGHT_GIT_REF))

include $(BUILD_LAYER)

$(light): bdir:=$(bdir)
$(light):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && git reset --hard && ./autogen.sh
	cd $(builddir)/$(bdir) && $(srcdir)/$(bdir)/configure
	cd $(builddir)/$(bdir) && $(MAKE) && $(MAKE) DESTDIR=$(builddir)/out install
	sudo cp -r $(builddir)/out/* /
	$(stamp)

