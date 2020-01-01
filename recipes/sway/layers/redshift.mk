LAYER:=redshift
include $(DEFINE_LAYER)

bdir:=$(LAYER)

redshift:=$(LSTAMP)/$(bdir)

$(L) += $(redshift)

$(call git_clone, $(bdir), https://github.com/minus7/redshift.git, wayland)

include $(BUILD_LAYER)

$(redshift): bdir:=$(bdir)
$(redshift): CC=gcc
$(redshift): CXX=g++
$(redshift):
	mkdir -p $(builddir)/$(bdir)
	cd $(builddir)/$(bdir) && $(srcdir)/$(bdir)/bootstrap && $(srcdir)/$(bdir)/configure
	cd $(builddir)/$(bdir) && $(MAKE) && sudo $(MAKE) install
	$(stamp)

