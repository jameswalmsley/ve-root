LAYER:=zathura

DEB_PACKAGES += libgirara-dev

ifeq ($(shell $(BASE)/scripts/version-parse.py --gteq $(shell pkg-config --modversion girara-gtk3) 0.3.3),y)

include $(DEFINE_LAYER)

bdir:=zathura

zathura:=$(LSTAMP)/$(bdir)
zathura-plugin-mupdf:=$(LSTAMP)/zathura-plugin-mupdf

$(L) += $(zathura)
$(L) += $(zathura-plugin-mupdf)

DEB_PACKAGES += mupdf

$(call git_clone, $(bdir), https://git.pwmt.org/pwmt/zathura.git, master)
$(call git_clone, zathura-plugin-mupdf, https://git.pwmt.org/pwmt/zathura-pdf-mupdf.git, master)

include $(BUILD_LAYER)

$(zathura): bdir:=$(bdir)
$(zathura):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) $(MESON_OPTIONS)
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/zathura && $(SUDO) ninja install
	$(stamp)

$(zathura-plugin-mupdf):
	mkdir -p $(builddir)/zathura-plugin-mupdf
	cd $(srcdir)/zathura-plugin-mupdf && meson $(builddir)/zathura-plugin-mupdf $(MESON_OPTIONS)
	cd $(builddir)/zathura-plugin-mupdf && ninja
	cd $(builddir)/zathura-plugin-mupdf && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/zathura-plugin-mupdf && $(SUDO) ninja install
	$(stamp)

$(zathura-plugin-mupdf): $(zathura)


endif
