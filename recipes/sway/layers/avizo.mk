LAYER:=avizo
include $(DEFINE_LAYER)

avizo:=$(LSTAMP)/avizo

$(L) += $(avizo)

DEB_PACKAGES += valac

$(call git_clone, avizo, https://github.com/misterdanb/avizo.git, master)

include $(BUILD_LAYER)

$(avizo):
	mkdir -p $(builddir)/avizo
	-cd $(srcdir)/avizo && meson $(builddir)/avizo --buildtype=release
	cd $(builddir)/avizo && ninja
	cd $(builddir)/avizo && sudo ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/avizo



