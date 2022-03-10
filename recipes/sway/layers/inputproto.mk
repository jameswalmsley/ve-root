LAYER:=inputproto
include $(DEFINE_LAYER)

inputproto_GIT_REF?=master

bdir:=$(LAYER)

inputproto:=$(LSTAMP)/$(bdir)

$(L) += $(inputproto)

$(call git_clone, $(bdir), https://github.com/freedesktop/xorg-xorgproto.git, $(inputproto_GIT_REF))

include $(BUILD_LAYER)

$(inputproto): bdir:=$(bdir)
$(inputproto):
	mkdir -p $(builddir)/$(bdir)
	cd $(builddir)/$(bdir) && $(srcdir)/$(bdir)/autogen.sh
	cd $(builddir)/$(bdir) && make && sudo make install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

