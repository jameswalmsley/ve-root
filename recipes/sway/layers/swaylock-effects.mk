LAYER:=swaylock-effects
include $(DEFINE_LAYER)

swaylock-effects:=$(LSTAMP)/swaylock-effects

$(L) += $(swaylock-effects)

$(call git_clone, swaylock-effects, https://github.com/mortie/swaylock-effects.git, master)

include $(BUILD_LAYER)

$(swaylock-effects):
	mkdir -p $(builddir)/swaylock-effects
	cd $(srcdir)/swaylock-effects && meson $(builddir)/swaylock-effects --buildtype=release
	cd $(builddir)/swaylock-effects && ninja -v
	cd $(builddir)/swaylock-effects && sudo ninja install
	$(stamp)

