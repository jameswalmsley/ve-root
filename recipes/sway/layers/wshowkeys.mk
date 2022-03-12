LAYER:=wshowkeys
include $(DEFINE_LAYER)

WSHOWKEYS_GIT_REF?=master

bdir:=wshowkeys

wshowkeys:=$(LSTAMP)/$(bdir)

$(L) += $(wshowkeys)

DEB_PACKAGES += libinput-dev

$(call git_clone, $(bdir), https://github.com/ammgws/wshowkeys, $(WSHOWKEYS_GIT_REF))

include $(BUILD_LAYER)

$(wshowkeys): bdir:=$(bdir)
$(wshowkeys):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) $(MESON_OPTIONS)
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && DESTDIR=$(SYSROOT) ninja install
	chmod a+s $(SYSROOT)/usr/local/bin/wshowkeys
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

