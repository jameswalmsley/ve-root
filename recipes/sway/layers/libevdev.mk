LAYER:=libevdev
include $(DEFINE_LAYER)

libevdev:=$(LSTAMP)/libevdev

$(L) += $(libevdev)

$(call git_clone, libevdev, https://gitlab.freedesktop.org/libevdev/libevdev.git, master)

include $(BUILD_LAYER)

$(libevdev):
	mkdir -p $(builddir)
	meson $(MESON_OPTIONS) $(srcdir)/libevdev $(builddir) -Dtests=disabled -Ddocumentation=disabled 
	cd $(builddir) && ninja
	cd $(builddir) && $(SUDO) ninja install 
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
