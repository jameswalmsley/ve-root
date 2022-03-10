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
	cd $(builddir)/pamixer && meson --buildtype=release $(srcdir)/pamixer $(builddir)/pamixer
	cd $(builddir)/pamixer && ninja
	cd $(builddir)/pamixer && sudo ninja install
	$(stamp)

