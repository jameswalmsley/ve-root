LAYER:=avizo
include $(DEFINE_LAYER)

avizo:=$(LSTAMP)/avizo

$(L) += $(avizo)

DEB_PACKAGES += valac

$(call git_clone, avizo, https://github.com/misterdanb/avizo.git, 1.2)

DEPENDS += glib
DEPENDS += sway
DEPENDS += xdg-layer-shell

include $(BUILD_LAYER)

$(avizo):
	mkdir -p $(builddir)/avizo
	-cd $(srcdir)/avizo && meson $(builddir)/avizo $(MESON_OPTIONS)
	cd $(builddir)/avizo && ninja
	cd $(builddir)/avizo && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/avizo



