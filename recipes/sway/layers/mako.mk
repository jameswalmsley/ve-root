LAYER:=mako
include $(DEFINE_LAYER)

mako:=$(LSTAMP)/mako

$(L) += $(mako)

$(call git_clone, mako, https://github.com/emersion/mako.git, master)

include $(BUILD_LAYER)

$(mako):
	mkdir -p $(builddir)/mako
	cd $(srcdir)/mako && meson $(builddir)/mako --buildtype=release
	cd $(builddir)/mako && ninja
	cd $(builddir)/mako && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
