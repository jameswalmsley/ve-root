LAYER:=gtkgreet
include $(DEFINE_LAYER)

GTKGREET_GIT_REF?=master

gtkgreet:=$(LSTAMP)/gtkgreet

$(L) += $(gtkgreet)

$(call git_clone, gtkgreet, https://git.sr.ht/~kennylevinsen/gtkgreet, $(GTKGREET_GIT_REF))

DEPENDS += sway
DEPENDS += glib

include $(BUILD_LAYER)

$(gtkgreet):
	mkdir -p $(builddir)/gtkgreet
	cd $(builddir)/gtkgreet && meson $(MESON_OPTIONS) $(srcdir)/gtkgreet
	cd $(builddir)/gtkgreet && ninja
	cd $(builddir)/gtkgreet && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/gtkgreet

