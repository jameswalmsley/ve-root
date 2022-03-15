LAYER:=swappy
include $(DEFINE_LAYER)

swappy_GIT_REF?=master

swappy:=$(LSTAMP)/swappy

$(L) += $(swappy)

$(call git_clone, swappy, https://github.com/jtheoof/swappy, $(swappy_GIT_REF))

DEPENDS += sway
DEPENDS += glib

DEB_RUN_PACKAGES += jq

include $(BUILD_LAYER)

$(swappy):
$(swappy):
	mkdir -p $(builddir)/swappy
	cd $(srcdir)/swappy && meson $(MESON_OPTIONS) $(srcdir)/swappy $(builddir)/swappy
	cd $(builddir)/swappy && ninja
	cd $(builddir)/swappy && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/swappy



