LAYER:=swaylock
include $(DEFINE_LAYER)

swaylock:=$(LSTAMP)/swaylock

$(L) += $(swaylock)

$(call git_clone, swaylock, https://github.com/swaywm/swaylock.git, master)

include $(BUILD_LAYER)

$(swaylock):
	mkdir -p $(builddir)/swaylock
	cd $(srcdir)/swaylock && meson $(builddir)/swaylock --buildtype=release
	cd $(builddir)/swaylock && ninja -v
	cd $(builddir)/swaylock && sudo ninja install
	$(stamp)

