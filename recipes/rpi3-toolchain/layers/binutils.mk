LAYER:=binutils
include $(DEFINE_LAYER)

binutils-configure:=$(LSTAMP)/binutils-configure
binutils:=$(LSTAMP)/binutils
binutils-install:=$(LSTAMP)/binutils-install

$(L) += $(binutils-configure)
$(L) += $(binutils)
$(L) += $(binutils-install)

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



$(binutils-configure):
	rm -rf $(builddir)/binutils
	mkdir -p $(builddir)/binutils
	cd $(builddir)/binutils && $(ENVFLAGS) $(srcdir)/binutils/configure --host=$(TC_HOST) --build=$(TC_BUILD) --target=$(TC_TARGET) --prefix=$(TC_PREFIX) $(BINUTILS_CONFIG)
	$(stamp)


$(binutils):
	cd $(builddir)/binutils && $(MAKE)
	$(stamp)

$(binutils): $(binutils-configure)

$(binutils-install):
	cd $(builddir)/binutils && $(MAKE) install
	$(stamp)

$(binutils-install): $(binutils)

binutils-docs: $(OUTDIR)/_binutils_build
	cd $(builddir)/binutils && $(MAKE) install-html install-pdf
	@touch $@
