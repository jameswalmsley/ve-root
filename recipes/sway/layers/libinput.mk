LAYER:=libinput
include $(DEFINE_LAYER)

libinput_GIT_REF?=1.19.3

libinput:=$(LSTAMP)/libinput

$(L) += $(libinput)

$(call git_clone, libinput, https://github.com/wayland-project/libinput.git, $(libinput_GIT_REF))

include $(BUILD_LAYER)

$(libinput):
	mkdir -p $(builddir)/libinput
	cd $(builddir)/libinput && meson $(MESON_OPTIONS) $(srcdir)/libinput $(builddir)/libinput
	cd $(builddir)/libinput && ninja
	cd $(builddir)/libinput && DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/libinput && $(SUDO) ninja install && rm -rf $(builddir)/libinput/meson-logs/install-log.txt
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/libinput

