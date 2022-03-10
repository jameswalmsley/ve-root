LAYER:=libdrm
include $(DEFINE_LAYER)

libdrm_GIT_REF?=master

bdir:=$(LAYER)

libdrm:=$(LSTAMP)/$(bdir)

$(L) += $(libdrm)

$(call git_clone, $(bdir), https://github.com/freedesktop/mesa-drm.git, $(libdrm_GIT_REF))

include $(BUILD_LAYER)

$(libdrm): bdir:=$(bdir)
$(libdrm):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

