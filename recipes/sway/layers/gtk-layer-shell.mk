LAYER:=gtk-layer-shell
include $(DEFINE_LAYER)

gtk-layer-shell_GIT_REF?=master

gtk-layer-shell:=$(LSTAMP)/gtk-layer-shell

$(L) += $(gtk-layer-shell)

$(call git_clone, gtk-layer-shell, https://github.com/wmww/gtk-layer-shell.git, $(gtk-layer-shell_GIT_REF))

DEPENDS += glib

include $(BUILD_LAYER)

$(gtk-layer-shell):
$(gtk-layer-shell):
	mkdir -p $(builddir)/gtk-layer-shell
	cd $(srcdir)/gtk-layer-shell && meson $(MESON_OPTIONS) $(srcdir)/gtk-layer-shell $(builddir)/gtk-layer-shell
	cd $(builddir)/gtk-layer-shell && ninja
	cd $(builddir)/gtk-layer-shell && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/gtk-layer-shell && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/gtk-layer-shell


