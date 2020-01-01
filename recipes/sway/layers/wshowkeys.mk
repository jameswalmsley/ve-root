LAYER:=wshowkeys
include $(DEFINE_LAYER)

bdir:=wshowkeys

wshowkeys:=$(LSTAMP)/$(bdir)

$(L) += $(wshowkeys)

$(call git_clone, $(bdir), https://git.sr.ht/~sircmpwn/wshowkeys, master)

include $(BUILD_LAYER)

$(wshowkeys): bdir:=$(bdir)
$(wshowkeys):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && sudo ninja install
	sudo chmod a+s /usr/local/bin/wshowkeys
	$(stamp)

$(L).clean:
	rm -rf $(builddir)

