LAYER:=wayland-protocols
include $(DEFINE_LAYER)

wayland-protocols:=$(LSTAMP)/wayland-protocols

$(L) += $(wayland-protocols)

$(call git_clone, wayland-protocols, https://github.com/wayland-project/wayland-protocols.git, master)

include $(BUILD_LAYER)

$(wayland-protocols):
	cd $(srcdir)/wayland-protocols && ./autogen.sh
	cd $(srcdir)/wayland-protocols && sudo make install
	$(stamp)


