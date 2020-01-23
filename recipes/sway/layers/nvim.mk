LAYER:=nvim
include $(DEFINE_LAYER)

nvim:=$(LSTAMP)/nvim

$(call git_clone, neovim, https://github.com/neovim/neovim.git, master)

$(L) += $(nvim)

include $(BUILD_LAYER)

$(nvim):
	-rm -rf $(builddir)
	mkdir -p $(builddir)/.deps
	cd $(builddir)/.deps && cmake -GNinja -DCMAKE_BUILD_TYPE=Release $(srcdir)/neovim/third-party
	cd $(builddir)/.deps && ninja
	mkdir -p $(builddir)/build
	cd $(builddir)/build && cmake -GNinja -DCMAKE_BUILD_TYPE=Release $(srcdir)/neovim -DUSE_BUNDLED=ON
	cd $(builddir)/build && ninja
	cd $(builddir)/build && sudo ninja install
	$(stamp)

