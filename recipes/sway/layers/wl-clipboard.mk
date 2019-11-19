LAYER:=wl-clipboard
include $(DEFINE_LAYER)

WL_CLIPBOARD_GIT_REF?=master

wl-clipboard:=$(LSTAMP)/wl-clipboard

$(L) += $(wl-clipboard)

$(call git_clone, wl-clipboard, https://github.com/bugaevc/wl-clipboard.git, $(WL_CLIPBOARD_GIT_REF))

include $(BUILD_LAYER)

$(wl-clipboard):
	mkdir -p $(builddir)/wl-clipboard
	cd $(srcdir)/wl-clipboard && meson $(builddir)/wl-clipboard --buildtype=release
	cd $(builddir)/wl-clipboard && ninja
	cd $(builddir)/wl-clipboard && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

