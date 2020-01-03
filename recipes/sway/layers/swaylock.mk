LAYER:=swaylock
include $(DEFINE_LAYER)

SWAYLOCK_GIT_REF?=master

swaylock:=$(LSTAMP)/swaylock

$(L) += $(swaylock)

$(call git_clone, swaylock, https://github.com/swaywm/swaylock.git, $(SWAYLOCK_GIT_REF))

include $(BUILD_LAYER)

$(swaylock):
	mkdir -p $(builddir)/swaylock
	cd $(srcdir)/swaylock && meson $(builddir)/swaylock --buildtype=release
	cd $(builddir)/swaylock && ninja
	cd $(builddir)/swaylock && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

