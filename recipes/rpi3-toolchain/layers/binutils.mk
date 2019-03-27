LAYER:=binutils
include $(DEFINE_LAYER)

binutils-configure:=$(TC_STAMP)/binutils-configure
binutils:=$(TC_STAMP)/binutils
binutils-install:=$(TC_STAMP)/binutils-install

$(L) += $(binutils-configure)
$(L) += $(binutils)
$(L) += $(binutils-install)

DEPENDS += toolchain-libs

$(call git_clone, binutils, https://github.com/bminor/binutils-gdb.git, binutils-2_32)

include $(BUILD_LAYER)

BINUTILS_CONFIG += --disable-nls
BINUTILS_CONFIG += --enable-interwork
BINUTILS_CONFIG += --disable-sim
BINUTILS_CONFIG += --disable-gdb
BINUTILS_CONFIG += --enable-plugins
BINUTILS_CONFIG += --with-sysroot
BINUTILS_CONFIG += --enable-multilib
BINUTILS_CONFIG += --infodir=$(DOCROOT)/info
BINUTILS_CONFIG += --mandir=$(DOCROOT)/man
BINUTILS_CONFIG += --pdfdir=$(DOCROOT)/pdf
BINUTILS_CONFIG += --enable-multiarch

$(binutils-configure):
	rm -rf $(builddir)/$(TC_HOST)/binutils
	mkdir -p $(builddir)/$(TC_HOST)/binutils
	cd $(builddir)/$(TC_HOST)/binutils && $(ENVFLAGS) $(srcdir)/binutils/configure --host=$(TC_HOST) --build=$(TC_BUILD) --target=$(TC_TARGET) --prefix=$(TC_PREFIX) $(BINUTILS_CONFIG)
	$(stamp)


$(binutils):
	cd $(builddir)/$(TC_HOST)/binutils && $(MAKE)
	$(stamp)

$(binutils): $(binutils-configure)

$(binutils-install):
	cd $(builddir)/$(TC_HOST)/binutils && $(MAKE) install
	$(stamp)

$(binutils-install): $(binutils)

binutils-docs: $(OUTDIR)/_binutils_build
	cd $(builddir)/$(TC_HOST)/binutils && $(MAKE) install-html install-pdf
	@touch $@
