LAYER:=grim
include $(DEFINE_LAYER)

GRIM_GIT_REF?=master

bdir:=grim

grim:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += libjpeg-dev

$(L) += $(grim)

$(call git_clone, $(bdir), https://github.com/emersion/grim.git, $(GRIM_GIT_REF))

include $(BUILD_LAYER)

$(grim): bdir:=$(bdir)
$(grim):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) $(MESON_OPTIONS)
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

