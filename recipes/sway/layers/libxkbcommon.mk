LAYER:=libxkbcommon
include $(DEFINE_LAYER)

libxkbcommon_GIT_REF?=xkbcommon-1.4.0

libxkbcommon:=$(LSTAMP)/libxkbcommon

$(L) += $(libxkbcommon)

$(call git_clone, libxkbcommon, https://github.com/xkbcommon/libxkbcommon.git, $(libxkbcommon_GIT_REF))

DEPENDS += xwayland

include $(BUILD_LAYER)

$(libxkbcommon):
	mkdir -p $(builddir)/libxkbcommon
	cd $(srcdir)/libxkbcommon && meson $(MESON_OPTIONS) $(srcdir)/libxkbcommon $(builddir)/libxkbcommon -Denable-x11=false -Denable-docs=false
	cd $(builddir)/libxkbcommon && ninja
	cd $(builddir)/libxkbcommon && $(SUDO) ninja install
	cd $(builddir)/libxkbcommon && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/libxkbcommon




