LAYER:=libinput
include $(DEFINE_LAYER)

libinput_GIT_REF?=1.19.3

libinput:=$(LSTAMP)/libinput

$(L) += $(libinput)

DEB_PACKAGES += check

$(call git_clone, libinput, https://github.com/wayland-project/libinput.git, $(libinput_GIT_REF))

DEPENDS += wayland
DEPENDS += wayland-protocols

include $(BUILD_LAYER)

$(libinput):
	mkdir -p $(builddir)/libinput
	cd $(builddir)/libinput && meson $(MESON_OPTIONS) $(srcdir)/libinput $(builddir)/libinput -Ddebug-gui=false -Dtests=false -Dlibwacom=false
	cd $(builddir)/libinput && ninja
	cd $(builddir)/libinput && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/libinput

