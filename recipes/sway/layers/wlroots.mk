LAYER:=wlroots
include $(DEFINE_LAYER)

wlroots:=$(LSTAMP)/wlroots

$(L) += $(wlroots)

$(call git_clone, wlroots, https://github.com/swaywm/wlroots.git, master)

DEPENDS += freerdp

include $(BUILD_LAYER)

$(wlroots):
	mkdir -p $(builddir)/wlroots
	cd $(builddir)/wlroots && meson --buildtype=release $(srcdir)/wlroots $(builddir)/wlroots
	cd $(builddir)/wlroots && ninja
	cd $(builddir)/wlroots && sudo ninja install
	$(stamp)


