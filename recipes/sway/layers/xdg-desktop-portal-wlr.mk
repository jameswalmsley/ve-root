LAYER:=xdg-desktop-portal-wlr
include $(DEFINE_LAYER)

XDG_DESKTOP_PORTAL_WLR_GIT_REF?=master

DEB_PACKAGES += libiniparser-dev

portal-wlr:=$(LSTAMP)/portal-wlr

$(L) += $(portal-wlr)

$(call git_clone, portal-wlr, https://github.com/emersion/xdg-desktop-portal-wlr.git, $(XDG_DESKTOP_PORTAL_WLR_GIT_REF))

include $(BUILD_LAYER)

$(portal-wlr):
	mkdir -p $(builddir)/portal-wlr
	cd $(srcdir)/portal-wlr && meson $(builddir)/portal-wlr --buildtype=release
	cd $(builddir)/portal-wlr && ninja
	cd $(builddir)/portal-wlr && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

