LAYER:=libxcvt
include $(DEFINE_LAYER)

libxcvt_GIT_REF?=main

libxcvt:=$(LSTAMP)/libxcvt

$(L) += $(libxcvt)

$(call git_clone, libxcvt, https://gitlab.freedesktop.org/xorg/lib/libxcvt.git, $(libxcvt_GIT_REF))

include $(BUILD_LAYER)

$(libxcvt):
	mkdir -p $(builddir)/libxcvt
	cd $(builddir)/libxcvt && meson $(MESON_OPTIONS) $(srcdir)/libxcvt $(builddir)/libxcvt
	cd $(builddir)/libxcvt && ninja
	cd $(builddir)/libxcvt && DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/libxcvt && $(SUDO) ninja install && rm -rf $(builddir)/libxcvt/meson-logs/install-log.txt
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/libxcvt


