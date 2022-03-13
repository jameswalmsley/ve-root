LAYER:=swayidle
include $(DEFINE_LAYER)

SWAYIDLE_GIT_REF?=master

bdir:=swayidle

swayidle:=$(LSTAMP)/$(bdir)

$(L) += $(swayidle)

$(call git_clone, $(bdir), https://github.com/swaywm/swayidle.git, $(SWAYIDLE_GIT_REF))

DEPENDS += sway

include $(BUILD_LAYER)

$(swayidle): bdir:=$(bdir)
$(swayidle):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) $(MESON_OPTIONS)
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

