LAYER:=wlroots
include $(DEFINE_LAYER)

wlroots:=$(LSTAMP)/wlroots

$(L) += $(wlroots)

$(call git_clone, wlroots, https://github.com/swaywm/wlroots.git, master)

include $(BUILD_LAYER)

$(wlroots):
	mkdir -p $(builddir)/wlroots
	cd $(srcdir)/wlroots && meson $(builddir)/wlroots --buildtype=release
	cd $(builddir)/wlroots && ninja -v
	cd $(builddir)/wlroots && sudo ninja install
	$(stamp)


