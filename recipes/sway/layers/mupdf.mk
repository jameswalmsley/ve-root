LAYER:=mupdf
include $(DEFINE_LAYER)

mupdf_GIT_REF?=1.19.0

mupdf:=$(LSTAMP)/mupdf

$(L) += $(mupdf)

DEB_PACKAGES += unzip

$(call git_clone, mupdf, git://git.ghostscript.com/mupdf.git, $(mupdf_GIT_REF))

include $(BUILD_LAYER)

$(mupdf):
	mkdir -p $(builddir)/mupdf
	CFLAGS=-fPIC $(MAKE) -C $(srcdir)/mupdf OUT=$(builddir)/mupdf
	$(SUDO) $(MAKE) -C $(srcdir)/mupdf OUT=$(builddir)/mupdf install
	$(stamp)

$(L).clean:
	rm -rf $(builddir)/mupdf

