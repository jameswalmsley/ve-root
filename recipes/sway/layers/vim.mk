LAYER:=vim
include $(DEFINE_LAYER)

bdir:=$(LAYER)

vim:=$(LSTAMP)/$(bdir)

$(L) += $(vim)

$(call git_clone, $(bdir), https://github.com/vim/vim.git, master)

include $(BUILD_LAYER)

$(vim): bdir:=$(bdir)
$(vim):
	-rm -rf $(builddir)
	mkdir -p $(builddir)/$(bdir)
	rsync -a $(srcdir)/vim $(builddir)
	cd $(builddir)/$(bdir) && ./configure --enable-gui=auto --with-x --enable-gtk2-check --enable-huge --enable-pythoninterp --prefix=/usr
	cd $(builddir)/$(bdir) && $(MAKE) && sudo $(MAKE) install
	$(stamp)
