LAYER:=pixman
include $(DEFINE_LAYER)

pixman:=$(LSTAMP)/pixman

$(L) += $(pixman)

$(call git_clone, pixman, https://gitlab.freedesktop.org/pixman/pixman.git, master)

include $(BUILD_LAYER)

$(pixman):
	mkdir -p $(builddir)
	meson $(MESON_OPTIONS) $(srcdir)/pixman $(builddir) -Dtests=disabled
	cd $(builddir) && ninja
	cd $(builddir) && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
