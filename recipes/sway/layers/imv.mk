LAYER:=imv
include $(DEFINE_LAYER)

bdir:=imv

imv:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += libfreeimage-dev
DEB_PACKAGES += asciidoc-base
DEB_PACKAGES += libcmocka-dev libjpeg-dev libtiff-dev

$(L) += $(imv)

$(call git_clone, $(bdir), https://github.com/eXeC64/imv.git, master)

include $(BUILD_LAYER)

$(imv): bdir:=$(bdir)
$(imv):
	mkdir -p $(builddir)/imv
	cd $(srcdir)/imv && meson $(builddir)/imv --buildtype=release
	cd $(builddir)/imv && ninja && sudo ninja install
	$(stamp)


