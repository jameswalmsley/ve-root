LAYER:=xwayland
include $(DEFINE_LAYER)

bdir:=xwayland

xwayland:=$(LSTAMP)/$(bdir)

$(L) += $(xwayland)

$(call git_clone, $(bdir), https://gitlab.freedesktop.org/xorg/xserver, master)

include $(BUILD_LAYER)

$(xwayland): bdir:=$(bdir)
$(xwayland):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release  -Dxwin=false -Dxorg=false -Dxquartz=false -Dxvfb=false -Dxnest=false
	cd $(builddir)/$(bdir) && ninja -v
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)


