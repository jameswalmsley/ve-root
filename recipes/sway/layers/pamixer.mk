LAYER:=pamixer
include $(DEFINE_LAYER)

PAMIXER_GIT_REF?=master

bdir:=$(LAYER)

pamixer:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += libboost-program-options-dev

$(L) += $(pamixer)

$(call git_clone, $(bdir), https://github.com/cdemoulins/pamixer.git, $(PAMIXER_GIT_REF))

include $(BUILD_LAYER)

$(pamixer): bdir:=$(bdir)
$(pamixer):
	mkdir -p $(builddir)/$(bdir)
	cp -r $(srcdir)/$(bdir)/* $(builddir)/$(bdir)/
	cd $(builddir)/$(bdir) && $(MAKE) && sudo $(MAKE) install
	$(stamp)

