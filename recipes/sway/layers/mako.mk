LAYER:=mako
include $(DEFINE_LAYER)

MAKO_GIT_REF?=master

mako:=$(LSTAMP)/mako

$(L) += $(mako)

$(call git_clone, mako, https://github.com/emersion/mako.git, $(MAKO_GIT_REF))

include $(BUILD_LAYER)

$(mako):
	mkdir -p $(builddir)/mako
	cd $(srcdir)/mako && meson $(builddir)/mako --buildtype=release
	cd $(builddir)/mako && ninja
	cd $(builddir)/mako && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
