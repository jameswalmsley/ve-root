LAYER:=sway
include $(DEFINE_LAYER)

sway:=$(LSTAMP)/sway

$(L) += $(sway)

$(call git_clone, sway, https://github.com/swaywm/sway.git, master)

include $(BUILD_LAYER)

$(sway):
	mkdir -p $(builddir)/sway
	cd $(srcdir)/sway && meson $(builddir)/sway --buildtype=release
	cd $(builddir)/sway && ninja -v
	cd $(builddir)/sway && sudo ninja install
	$(stamp)

