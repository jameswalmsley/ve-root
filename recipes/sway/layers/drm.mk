LAYER:=drm
include $(DEFINE_LAYER)

drm_GIT_REF?=libdrm-2.4.109

drm:=$(LSTAMP)/drm

$(L) += $(drm)

DEB_PACKAGES += libpciaccess-dev

$(call git_clone, drm, https://gitlab.freedesktop.org/mesa/drm.git, $(drm_GIT_REF))

include $(BUILD_LAYER)

$(drm):
	mkdir -p $(builddir)/drm
	cd $(builddir)/drm && meson $(MESON_OPTIONS) $(srcdir)/drm $(builddir)/drm -Dinstall-test-programs=false
	cd $(builddir)/drm && ninja
	cd $(builddir)/drm && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	cd $(builddir)/drm && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/drm

