LAYER:=tmux
include $(DEFINE_LAYER)

tmux:=$(LSTAMP)/tmux

DEB_PACKAGES += libevent-dev


$(call git_clone, tmux, https://github.com/tmux/tmux, 3.1)

$(L) += $(tmux)

include $(BUILD_LAYER)

$(tmux):
	rm -rf $(builddir)
	mkdir -p $(builddir)/tmux
	cd $(srcdir)/tmux && ./autogen.sh
	cd $(builddir)/tmux && $(srcdir)/tmux/configure --prefix=$$HOME/.local
	cd $(builddir)/tmux && $(MAKE)
	cd $(builddir)/tmux && $(MAKE) install
	$(stamp)


$(tmux).clean:
	rm -rf $(builddir)

