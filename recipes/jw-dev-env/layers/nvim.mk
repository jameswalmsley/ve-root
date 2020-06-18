LAYER:=nvim
include $(DEFINE_LAYER)

nvim:=$(LSTAMP)/nvim
vim-plug:=$(LSTAMP)/vim-plug

DEB_PACKAGES += lua-argparse
DEB_PACKAGES += ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
DEB_PACKAGES += gperf libluajit-5.1-dev libunibilium-dev libmsgpack-dev libtermkey-dev \
				libvterm-dev libjemalloc-dev lua5.1 lua-lpeg lua-mpack lua-bitop
$(call git_clone, neovim, https://github.com/neovim/neovim.git, master)

$(L) += $(nvim)
$(L) += $(vim-plug)

include $(BUILD_LAYER)

$(nvim):
	-rm -rf $(builddir)
	cp -r $(srcdir)/* $(builddir)
	cd $(builddir) && CMAKE_BUILD_TYPE=Release $(MAKE)
	cd $(builddir) && sudo $(MAKE) install
	$(stamp)

$(vim-plug): $(nvim)
$(vim-plug):
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim -E -c PlugInstall -c q -c q

$(nvim).clean:
	rm -rf $(builddir)


