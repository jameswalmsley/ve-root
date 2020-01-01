LAYER:=grim
include $(DEFINE_LAYER)

bdir:=grim

grim:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += libjpeg-dev

$(L) += $(grim)

$(call git_clone, $(bdir), https://github.com/emersion/grim.git, master)

include $(BUILD_LAYER)

$(grim): bdir:=$(bdir)
$(grim):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja -v
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)


