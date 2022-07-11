LAYER:=wf-recorder
include $(DEFINE_LAYER)

WF_RECORDER_GIT_REF?=master

bdir:=wf-recorder

wf-recorder:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += libavdevice-dev
DEB_PACKAGES += libswscale-dev

$(L) += $(wf-recorder)

DEPENDS += sway

$(call git_clone, $(bdir), https://github.com/ammen99/wf-recorder.git, $(WF_RECORDER_GIT_REF))

include $(BUILD_LAYER)

$(wf-recorder): bdir:=$(bdir)
$(wf-recorder):
	mkdir -p $(builddir)/$(bdir)
	cd $(srcdir)/$(bdir) && meson $(builddir)/$(bdir) $(MESON_OPTIONS)
	cd $(builddir)/$(bdir) && ninja
	cd $(builddir)/$(bdir) && $(SUDO) ninja install
	$(stamp)


