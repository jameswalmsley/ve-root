LAYER:=fish
include $(DEFINE_LAYER)

fish:=$(LSTAMP)/fish

$(call git_clone, fish, https://github.com/fish-shell/fish-shell.git, 3.1.2)

$(L) += $(fish)

include $(BUILD_LAYER)

$(fish):
	-rm -rf $(builddir)
	mkdir -p $(builddir)/fish
	cd $(builddir)/fish && cmake -GNinja -DCMAKE_BUILD_TYPE=Release $(srcdir)/fish
	cd $(builddir)/fish && ninja
	cd $(builddir)/fish && ninja install
	$(stamp)


$(fish).clean:
	rm -rf $(builddir)


