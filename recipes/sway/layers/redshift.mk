LAYER:=redshift
include $(DEFINE_LAYER)

REDSHIFT_GIT_REF?=master
DEB_PACKAGES += intltool

bdir:=$(LAYER)

redshift:=$(LSTAMP)/$(bdir)

$(L) += $(redshift)

$(call git_clone, $(bdir), https://gitlab.com/chinstrap/gammastep.git, $(REDSHIFT_GIT_REF))

include $(BUILD_LAYER)

$(redshift): bdir:=$(bdir)
$(redshift): CC=gcc
$(redshift): CXX=g++
$(redshift):
	mkdir -p $(builddir)/$(bdir)
	cd $(builddir)/$(bdir) && $(srcdir)/$(bdir)/bootstrap && $(srcdir)/$(bdir)/configure
	cd $(builddir)/$(bdir) && $(MAKE) && sudo $(MAKE) install
	$(stamp)

