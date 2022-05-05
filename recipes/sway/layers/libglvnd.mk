
LAYER:=libglvnd
include $(DEFINE_LAYER)

libglvnd_GIT_REF?=master

bdir:=$(LAYER)

libglvnd:=$(LSTAMP)/$(bdir)

$(L) += $(libglvnd)

$(call git_clone, $(bdir), https://github.com/NVIDIA/libglvnd.git, $(libglvnd_GIT_REF))

include $(BUILD_LAYER)

$(libglvnd): bdir:=$(bdir)
$(libglvnd):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
