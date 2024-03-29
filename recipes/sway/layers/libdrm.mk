LAYER:=libdrm
include $(DEFINE_LAYER)

libdrm_GIT_REF?=libdrm-2.4.109

libdrm:=$(LSTAMP)/libdrm

$(L) += $(libdrm)

DEB_PACKAGES += libpciaccess-dev
DEB_PACKAGES += libcairo-dev

$(call git_clone, libdrm, https://github.com/freedesktop/mesa-drm.git, $(libdrm_GIT_REF))

include $(BUILD_LAYER)

$(libdrm):
$(libdrm):
	mkdir -p $(builddir)/libdrm
	cd $(srcdir)/libdrm && meson $(MESON_OPTIONS) $(srcdir)/libdrm $(builddir)/libdrm -Dinstall-test-programs=false -Dcairo-tests=false -Dvalgrind=false -Dintel=true
	cd $(builddir)/libdrm && ninja
	cd $(builddir)/libdrm && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/libdrm

