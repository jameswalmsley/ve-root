LAYER:=vim
include $(DEFINE_LAYER)

bdir:=$(LAYER)

vim:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += libx11-dev
DEB_PACKAGES += libxt-dev
DEB_PACKAGES += libncurses-dev
DEB_PACKAGES += libpython-dev

$(L) += $(vim)

$(call git_clone, $(bdir), https://github.com/vim/vim.git, master)

include $(BUILD_LAYER)

$(vim): bdir:=$(bdir)
$(vim):
	-rm -rf $(builddir)
	mkdir -p $(builddir)/$(bdir)
	rsync -a $(srcdir)/vim $(builddir)
	cd $(builddir)/$(bdir) && ./configure --with-x --enable-gui=gtk2 --enable-pythoninterp --prefix=/usr
	cd $(builddir)/$(bdir) && $(MAKE) && sudo $(MAKE) install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

