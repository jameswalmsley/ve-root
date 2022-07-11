LAYER:=wshowkeys
include $(DEFINE_LAYER)

WSHOWKEYS_GIT_REF?=main

wshowkeys:=$(LSTAMP)/wshowkeys

$(L) += $(wshowkeys)

DEB_PACKAGES += libinput-dev

$(call git_clone, wshowkeys, https://github.com/ammgws/wshowkeys, $(WSHOWKEYS_GIT_REF))

DEPENDS += sway

include $(BUILD_LAYER)

$(wshowkeys):
	mkdir -p $(builddir)
	cd $(srcdir)/wshowkeys && meson $(builddir) $(MESON_OPTIONS)
	cd $(builddir) && ninja
	cd $(builddir) && $(SUDO) ninja install
	$(SUDO) chmod a+s $(SYSROOT)/usr/local/bin/wshowkeys
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

