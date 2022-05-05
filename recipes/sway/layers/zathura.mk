LAYER:=zathura

DEB_PACKAGES += libgirara-dev

ifeq ($(shell $(BASE)/scripts/version-parse.py --gteq $(shell pkg-config --modversion girara-gtk3) 0.3.3),y)

include $(DEFINE_LAYER)

zathura:=$(LSTAMP)/zathura
zathura-plugin-mupdf:=$(LSTAMP)/zathura-plugin-mupdf
zathura-plugin-poppler:=$(LSTAMP)/zathura-plugin-poppler

$(L) += $(zathura)

$(L) += $(zathura-plugin-mupdf)

ifeq ($(CONFIG_ZATHURA_POPPLER),y)
$(L) += $(zathura-plugin-poppler)
endif

DEB_PACKAGES += mupdf
DEB_PACKAGES += libpoppler-glib-dev

$(call git_clone, zathura, https://git.pwmt.org/pwmt/zathura.git, master)
$(call git_clone, zathura-plugin-mupdf, https://git.pwmt.org/pwmt/zathura-pdf-mupdf.git, master)
$(call git_clone, zathura-plugin-poppler, https://github.com/pwmt/zathura-pdf-poppler.git, master)

DEPENDS += mupdf

include $(BUILD_LAYER)

$(zathura): bdir:=zathura
$(zathura):
	mkdir -p $(builddir)/zathura
	cd $(srcdir)/zathura && meson $(builddir)/zathura $(MESON_OPTIONS)
	cd $(builddir)/zathura && ninja
	cd $(builddir)/zathura && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(zathura-plugin-mupdf):
	mkdir -p $(builddir)/zathura-plugin-mupdf
	cd $(srcdir)/zathura-plugin-mupdf && meson $(builddir)/zathura-plugin-mupdf $(MESON_OPTIONS)
	cd $(builddir)/zathura-plugin-mupdf && ninja
	cd $(builddir)/zathura-plugin-mupdf && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(zathura-plugin-poppler):
	mkdir -p $(builddir)/zathura-plugin-poppler
	cd $(srcdir)/zathura-plugin-poppler && meson $(builddir)/zathura-plugin-poppler $(MESON_OPTIONS)
	cd $(builddir)/zathura-plugin-poppler && ninja
	cd $(builddir)/zathura-plugin-poppler && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(zathura-plugin-mupdf): $(zathura)
$(zathura-plugin-poppler): $(zathura)

$(L).clean:
	rm -rf $(builddir)


endif
