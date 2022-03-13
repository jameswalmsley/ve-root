LAYER:=glib
include $(DEFINE_LAYER)

glib_GIT_REF?=2.71.3

glib:=$(LSTAMP)/glib

$(L) += $(glib)

$(call git_clone, glib, https://github.com/GNOME/glib.git, $(glib_GIT_REF))

include $(BUILD_LAYER)

$(glib):
	mkdir -p $(builddir)/glib
	cd $(builddir)/glib && meson $(srcdir)/glib $(builddir)/glib $(MESON_OPTIONS) -Dinstalled_tests=false
	cd $(builddir)/glib && ninja
	cd $(builddir)/glib && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/glib && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/glib

