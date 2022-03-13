LAYER:=kanshi
include $(DEFINE_LAYER)

KANSHI_GIT_REF?=master

bdir:=$(LAYER)

kanshi:=$(LSTAMP)/$(bdir)

$(L) += $(kanshi)

DEPENDS += sway

$(call git_clone, $(bdir), https://github.com/emersion/kanshi.git, $(KANSHI_GIT_REF))

include $(BUILD_LAYER)

$(kanshi): bdir:=$(bdir)
$(kanshi):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir)
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && $(SUDO) DESTDIR=$(SYSROOT) ninja install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)
