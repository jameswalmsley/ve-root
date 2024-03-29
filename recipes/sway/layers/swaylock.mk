LAYER:=swaylock
include $(DEFINE_LAYER)

SWAYLOCK_GIT_REF?=1.6

swaylock:=$(LSTAMP)/swaylock

$(L) += $(swaylock)

$(call git_clone, swaylock, https://github.com/swaywm/swaylock.git, $(SWAYLOCK_GIT_REF))

DEPENDS += sway

include $(BUILD_LAYER)

$(swaylock):
	mkdir -p $(builddir)/swaylock
	cd $(srcdir)/swaylock && meson $(builddir)/swaylock $(MESON_OPTIONS)
	cd $(builddir)/swaylock && ninja
	cd $(builddir)/swaylock && DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

