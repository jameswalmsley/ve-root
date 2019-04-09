LAYER:=waybar
include $(DEFINE_LAYER)

waybar:=$(LSTAMP)/waybar

$(L) += $(waybar)

$(call git_clone, waybar, https://github.com/Alexays/Waybar.git, master)

include $(BUILD_LAYER)

$(waybar):
	mkdir -p $(builddir)/waybar
	cd $(srcdir)/waybar && meson $(builddir)/waybar --buildtype=release
	cd $(builddir)/waybar && ninja -v
	cd $(builddir)/waybar && sudo ninja install
	$(stamp)

