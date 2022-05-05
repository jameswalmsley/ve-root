LAYER:=scdoc
include $(DEFINE_LAYER)

SCDOC_GIT_REF?=master

scdoc:=$(LSTAMP)/scdoc

$(L) += $(scdoc)

$(call git_clone, scdoc, https://git.sr.ht/~sircmpwn/scdoc, $(SCDOC_GIT_REF))

include $(BUILD_LAYER)

$(scdoc):
	cd $(srcdir)/scdoc && $(MAKE) OUTDIR=$(builddir)/scdoc
	cd $(srcdir)/scdoc && $(SUDO) $(MAKE) OUTDIR=$(builddir)/scdoc DESTDIR=$(SYSROOT) install
	$(stamp)


