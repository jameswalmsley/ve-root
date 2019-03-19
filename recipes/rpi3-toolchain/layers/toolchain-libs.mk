LAYER:=toolchain-libs
include $(DEFINE_LAYER)

zlib:=$(LSTAMP)/zlib
libgmp:=$(LSTAMP)/libgmp
libmpfr:=$(LSTAMP)/libmpfr
libmpc:=$(LSTAMP)/libmpc
libisl:=$(LSTAMP)/libisl
libexpat:=$(LSTAMP)/libexpat

$(L) += $(zlib)
$(L) += $(libgmp)
$(L) += $(libmpfr)
$(L) += $(libmpc)
$(L) += $(libisl)
$(L) += $(libexpat)

$(call git_clone, zlib, https://github.com/madler/zlib.git, v1.2.8)
$(call get_archive, libgmp, https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2)

include $(BUILD_LAYER)

$(zlib):
	rm -rf $(builddir)/zlib
	mkdir -p $(builddir)/zlib
	cp -r $(srcdir)/zlib/* $(builddir)/zlib/
	cd $(builddir)/zlib && $(HOSTENV) ./configure --static --prefix=$(hostlibs)/zlib
	cd $(builddir)/zlib && $(MAKE)
	cd $(builddir)/zlib && $(MAKE) install
	$(stamp)

$(libgmp):
	rm -rf $(builddir)/libgmp
	mkdir -p $(builddir)/libgmp
	cd $(builddir)/libgmp && CPPFLAGS="-fexceptions" $(srcdir)/libgmp/configure \
		--host=$(HOST) \
		--build=$(BUILD) \
		--prefix=$(hostlibs)/usr \
		--enable-cxx \
		--disable-shared
	cd $(builddir)/libgmp && $(MAKE)
	cd $(builddir)/libgmp && $(MAKE) install
	$(stamp)

