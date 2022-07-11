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
	cd $(builddir)/$(bdir) && $(srcdir)/$(bdir)/configure --prefix=$(SYSROOT)/usr/local
	cd $(builddir)/$(bdir) && $(MAKE)
	cd $(builddir)/light && $(SUDO) $(MAKE) install
	$(stamp)

