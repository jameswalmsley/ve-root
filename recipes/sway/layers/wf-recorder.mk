LAYER:=wf-recorder
include $(DEFINE_LAYER)

bdir:=wf-recorder

wf-recorder:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += libavdevice-dev
DEB_PACKAGES += libswscale-dev

$(L) += $(wf-recorder)

$(call git_clone, $(bdir), https://github.com/ammen99/wf-recorder.git, master)

include $(BUILD_LAYER)

$(wf-recorder): bdir:=$(bdir)
$(wf-recorder):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) --buildtype=release
	cd $(builddir)/$(bdir) && ninja -v
	cd $(builddir)/$(bdir) && sudo ninja install
	$(stamp)


