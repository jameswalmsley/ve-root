LAYER:=xorgproto
include $(DEFINE_LAYER)

xorgproto_GIT_REF?=xorgproto-2021.5

bdir:=$(LAYER)

xorgproto:=$(LSTAMP)/$(bdir)

$(L) += $(xorgproto)

$(call git_clone, $(bdir), https://github.com/freedesktop/xorg-xorgproto.git, $(xorgproto_GIT_REF))

include $(BUILD_LAYER)

$(xorgproto): bdir:=$(bdir)
$(xorgproto):
	mkdir -p $(builddir)/$(bdir)
	cd $(builddir)/$(bdir) && $(srcdir)/$(bdir)/autogen.sh
	cd $(builddir)/$(bdir) && make && $(SUDO) make DESTDIR=$(SYSROOT) install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

