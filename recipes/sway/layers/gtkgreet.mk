LAYER:=gtkgreet
include $(DEFINE_LAYER)

GTKGREET_GIT_REF?=master

gtkgreet:=$(LSTAMP)/gtkgreet

$(L) += $(gtkgreet)

$(call git_clone, gtkgreet, https://git.sr.ht/~kennylevinsen/gtkgreet, $(GTKGREET_GIT_REF))

include $(BUILD_LAYER)

$(gtkgreet):
	cd $(srcdir)/gtkgreet && meson $(builddir)
	cd $(builddir) && ninja
	cd $(builddir) && sudo ninja install
	$(stamp)

