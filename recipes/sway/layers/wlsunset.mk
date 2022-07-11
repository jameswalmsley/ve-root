LAYER:=wlsunset
include $(DEFINE_LAYER)

wlsunset_GIT_REF?=master

wlsunset:=$(LSTAMP)/wlsunset

$(L) += $(wlsunset)

$(call git_clone, wlsunset, https://git.sr.ht/~kennylevinsen/wlsunset, $(wlsunset_GIT_REF))

DEPENDS += sway

include $(BUILD_LAYER)

$(wlsunset):
$(wlsunset):
	mkdir -p $(builddir)/wlsunset
	cd $(srcdir)/wlsunset && meson $(MESON_OPTIONS) $(srcdir)/wlsunset $(builddir)/wlsunset
	cd $(builddir)/wlsunset && ninja
	cd $(builddir)/wlsunset && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/wlsunset


