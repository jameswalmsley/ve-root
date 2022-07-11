LAYER:=pamixer
include $(DEFINE_LAYER)

PAMIXER_GIT_REF?=master

bdir:=$(LAYER)

pamixer:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += libboost-program-options-dev

$(L) += $(pamixer)

$(call git_clone, $(bdir), https://github.com/cdemoulins/pamixer.git, $(PAMIXER_GIT_REF))

DEPENDS += cxxopts

include $(BUILD_LAYER)

$(pamixer): bdir:=$(bdir)
$(pamixer):
	mkdir -p $(builddir)/$(bdir)
	cd $(builddir)/pamixer && meson $(srcdir)/pamixer $(builddir)/pamixer $(MESON_OPTIONS)
	cd $(builddir)/pamixer && ninja
	cd $(builddir)/pamixer && $(SUDO) ninja install
	$(stamp)

