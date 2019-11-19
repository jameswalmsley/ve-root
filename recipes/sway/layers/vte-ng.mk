LAYER:=vte-ng
include $(DEFINE_LAYER)

VTE_NG_GIT_REF?=0.50.2-ng

bdir:=$(LAYER)

vte-ng:=$(LSTAMP)/$(bdir)

DEB_PACKAGES += gtk-doc-tools
DEB_PACKAGES += intltool
DEB_PACKAGES += libgnutls28-dev
DEB_PACKAGES += gperf
DEB_PACKAGES += libxml2-utils
DEB_PACKAGES += gobject-introspection

$(L) += $(vte-ng)

$(call git_clone, $(bdir), https://github.com/thestinger/vte-ng.git, $(VTE_NG_GIT_REF))

include $(BUILD_LAYER)

$(vte-ng): bdir:=$(bdir)
$(vte-ng):
	mkdir -p $(builddir)/$(bdir)
	rsync -av --exclude=.git $(srcdir)/$(bdir) $(builddir)/
	cd $(builddir)/$(bdir) && ./autogen.sh --disable-introspection --disable-vala
	#cd $(builddir)/$(bdir) && ./configure
	cd $(builddir)/$(bdir) && $(MAKE) && sudo $(MAKE) install
	$(stamp)

