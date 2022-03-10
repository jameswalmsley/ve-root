LAYER:=drm
include $(DEFINE_LAYER)

drm_GIT_REF?=main

drm:=$(LSTAMP)/drm

$(L) += $(drm)

DEB_PACKAGES += libpciaccess-dev

$(call git_clone, drm, https://gitlab.freedesktop.org/mesa/drm.git, $(drm_GIT_REF))

include $(BUILD_LAYER)

$(drm):
	mkdir -p $(builddir)/drm
	cd $(builddir)/drm && meson --buildtype=release $(srcdir)/drm $(builddir)/drm
	cd $(builddir)/drm && ninja
	cd $(builddir)/drm && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/drm

