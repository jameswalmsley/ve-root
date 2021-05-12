LAYER:=pipewire
include $(DEFINE_LAYER)

PIPEWIRE_GIT_REF?=master

DEB_PACKAGES += libiniparser-dev

pipewire:=$(LSTAMP)/portal-wlr

$(L) += $(pipewire)

$(call git_clone, pipewire, https://github.com/pipewire/pipewire.git, $(PIPEWIRE_GIT_REF))

include $(BUILD_LAYER)

$(pipewire):
	mkdir -p $(builddir)/pipewire
	cd $(srcdir)/pipewire && meson $(builddir)/pipewire --buildtype=release
	cd $(builddir)/pipewire && ninja
	cd $(builddir)/pipewire && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
