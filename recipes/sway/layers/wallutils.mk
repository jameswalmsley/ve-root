LAYER:=wallutils
include $(DEFINE_LAYER)

wallutils:=$(LSTAMP)/wallutils

$(L) += $(wallutils)

$(call git_clone, wallutils, https://github.com/xyproto/wallutils.git, master)

include $(BUILD_LAYER)

$(wallutils):
	mkdir -p $(builddir)/wallutils
	cd $(srcdir)/wallutils && meson $(builddir)/wallutils --buildtype=release
	cd $(builddir)/wallutils && ninja -v
	cd $(builddir)/wallutils && sudo ninja install
	$(stamp)

