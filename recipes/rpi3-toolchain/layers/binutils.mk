LAYER:=binutils
include $(DEFINE_LAYER)

binutils:=$(LSTAMP)/binutils

$(L) += $(binutils)

DEPENDS += toolchain-libs

$(call git_clone, binutils, https://github.com/bminor/binutils-gdb.git, binutils-2_29_1.1)

include $(BUILD_LAYER)


BINUTILS_CONFIG += --disable-nls
BINUTILS_CONFIG += --enable-interwork
BINUTILS_CONFIG += --disable-sim
BINUTILS_CONFIG += --disable-gdb
BINUTILS_CONFIG += --enable-plugins
BINUTILS_CONFIG += --with-sysroot=$(SYSROOT)
BINUTILS_CONFIG += --infodir=$(DOCROOT)/info
BINUTILS_CONFIG += --mandir=$(DOCROOT)/man
BINUTILS_CONFIG += --pdfdir=$(DOCROOT)/pdf

$(binutils):
	rm -rf $(builddir)/binutils
	@mkdir -p $(builddir)/binutils
	cd $(builddir)/binutils && $(ENVFLAGS) $(srcdir)/binutils/configure --host=$(TC_HOST) --build=$(TC_BUILD) --target=$(TC_TARGET) --prefix=$(TC_PREFIX) $(BINUTILS_CONFIG)
	cd $(builddir)/binutils && $(MAKE)
	cd $(builddir)/binutils && $(MAKE) install
	$(stamp)

binutils-docs: $(OUTDIR)/_binutils_build
	cd $(builddir)/binutils && $(MAKE) install-html install-pdf
	@touch $@