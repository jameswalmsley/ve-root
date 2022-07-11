LAYER:=libva
include $(DEFINE_LAYER)

libva_GIT_REF?=2.14.0

libva:=$(LSTAMP)/libva

$(L) += $(libva)

$(call git_clone, libva, https://github.com/intel/libva.git, $(libva_GIT_REF))

DEPENDS += sway
DEPENDS += libdrm
DEPENDS += mesa
DEPENDS += wayland

include $(BUILD_LAYER)

$(libva):
	mkdir -p $(builddir)/libva
	cd $(srcdir)/libva && meson $(MESON_OPTIONS) $(srcdir)/libva $(builddir)/libva
	cd $(builddir)/libva && ninja
	cd $(builddir)/libva && $(SUDO) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/libva




