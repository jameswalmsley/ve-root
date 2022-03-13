LAYER:=swaylock-effects
include $(DEFINE_LAYER)

SWAYLOCK_EFFECTS_GIT_REF?=v1.6-3

swaylock-effects:=$(LSTAMP)/swaylock-effects

$(L) += $(swaylock-effects)

DEB_PACKAGES += clang-12

$(call git_clone, swaylock-effects, https://github.com/mortie/swaylock-effects.git, $(SWAYLOCK_EFFECTS_GIT_REF))

include $(BUILD_LAYER)

$(swaylock-effects):
	mkdir -p $(builddir)/swaylock-effects
	cd $(srcdir)/swaylock-effects && CC=$(CLANG) meson $(builddir)/swaylock-effects $(MESON_OPTIONS)
	cd $(builddir)/swaylock-effects && ninja
	cd $(builddir)/swaylock-effects && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
