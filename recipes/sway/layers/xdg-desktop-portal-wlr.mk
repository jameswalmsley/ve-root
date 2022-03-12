LAYER:=xdg-desktop-portal-wlr
include $(DEFINE_LAYER)

XDG_DESKTOP_PORTAL_WLR_GIT_REF?=master

DEB_PACKAGES += libiniparser-dev

DEB_RUN_PACKAGES += libinih1

portal-wlr:=$(LSTAMP)/portal-wlr

$(L) += $(portal-wlr)

$(call git_clone, portal-wlr, https://github.com/emersion/xdg-desktop-portal-wlr.git, $(XDG_DESKTOP_PORTAL_WLR_GIT_REF))

include $(BUILD_LAYER)

$(portal-wlr): export C_INCLUDE_PATH=/usr/include/iniparser
$(portal-wlr):
	mkdir -p $(builddir)/portal-wlr
	cd $(srcdir)/portal-wlr && meson $(builddir)/portal-wlr $(MESON_OPTIONS)
	cd $(builddir)/portal-wlr && ninja
	cd $(builddir)/portal-wlr && DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
