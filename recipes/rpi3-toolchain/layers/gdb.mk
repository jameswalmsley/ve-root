LAYER:=gdb
include $(DEFINE_LAYER)

gdb-configure:=$(TC_STAMP)/gdb-configure
gdb:=$(TC_STAMP)/gdb

$(L) += $(gdb-configure)
$(L) += $(gdb)

include $(BUILD_LAYER)

$(gdb-configure):
	rm -rf $(BUILD)/gdb
	mkdir -p $(BUILD)/gdb
	cd $(BUILD)/gdb && $(SRC_binutils)/binutils/configure \
		--build=$(TC_BUILD) \
		--host=$(TC_HOST) \
    	--target=$(TC_TARGET) \
		--prefix=$(TC_PREFIX) \
		--with-gmp=$(hostlibs)/usr \
		--with-mpfr=$(hostlibs)/usr \
		--with-mpc=$(hostlibs)/usr \
		--with-isl=$(hostlibs)/usr \
		--with-libelf=$(hostlibs)/usr \
		--with-libiconv-prefix=$(hostlibs)/usr \
		--with-zlib=$(hostlibs)/usr \
		--infodir=$(TC_PREFIX)/info \
		--mandir=$(TC_PREFIX)/man \
		--htmldir=$(TC_PREFIX)/html \
		--pdfdir=$(TC_PREFIX)/pdf \
		--disable-nls \
		--disable-sim \
		--disable-gas \
		--disable-binutils \
		--disable-ld \
		--disable-gprof \
		--with-libexpat \
		--with-lzma=no \
		--with-system-gdbinit=$(TC_PREFIX)/$(TC_TARGET)/lib/gdbinit \
		--with-libexpat-prefix=$(hostlibs)/usr \
		--with-python=no \
		'--with-gdb-datadir='\''${TC_PREFIX}'\''/$(TC_TARGET)/share/gdb'
		$(stamp)

$(gdb): $(gdb-configure)

$(gdb):
	cd $(BUILD)/gdb && $(MAKE)
	cd $(BUILD)/gdb && $(MAKE) install
	$(stamp)