LAYER:=mako
include $(DEFINE_LAYER)

MAKO_GIT_REF?=master

mako:=$(LSTAMP)/mako

$(L) += $(mako)

$(call git_clone, mako, https://github.com/emersion/mako.git, $(MAKO_GIT_REF))

DEPENDS += sway


include $(BUILD_LAYER)

$(mako):
	mkdir -p $(builddir)/mako
	cd $(srcdir)/mako && meson $(builddir)/mako $(MESON_OPTIONS)
	cd $(builddir)/mako && ninja
	cd $(builddir)/mako && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
