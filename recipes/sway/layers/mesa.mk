LAYER:=mesa
include $(DEFINE_LAYER)

mesa_GIT_REF?=main

mesa:=$(LSTAMP)/mesa

$(L) += $(mesa)

DEB_PACKAGES += llvm-12

$(call git_clone, mesa, https://gitlab.freedesktop.org/mesa/mesa.git, $(mesa_GIT_REF))

include $(BUILD_LAYER)

$(mesa):
	mkdir -p $(builddir)/mesa
	cd $(builddir)/mesa && meson --buildtype=release $(srcdir)/mesa $(builddir)/mesa
	cd $(builddir)/mesa && ninja
	cd $(builddir)/mesa && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/mesa

#
