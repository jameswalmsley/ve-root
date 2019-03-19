LAYER:=toolchain-libs
include $(DEFINE_LAYER)

zlib:=$(LSTAMP)/zlib
libgmp:=$(LSTAMP)/libgmp
libmpfr:=$(LSTAMP)/libmpfr
libmpc:=$(LSTAMP)/libmpc
libisl:=$(LSTAMP)/libisl
libexpat:=$(LSTAMP)/libexpat

VER_GMP:=6.1.0
VER_MPFR:=3.1.4
VER_MPC:=1.0.3
VER_ISL:=0.15
VER_EXPAT:=2.1.1
VER_LIBELF:=0.8.13
VER_LIBICONV:=1.14

$(L) += $(zlib)
$(L) += $(libgmp)
$(L) += $(libmpfr)
$(L) += $(libmpc)
$(L) += $(libisl)
$(L) += $(libexpat)

$(call git_clone, zlib, https://github.com/madler/zlib.git, v1.2.8)
$(call get_archive, libgmp, https://gmplib.org/download/gmp/gmp-$(VER_GMP).tar.bz2)
$(call get_archive, libmpfr, https://www.mpfr.org/mpfr-$(VER_MPFR)/mpfr-$(VER_MPFR).tar.bz2)
$(call get_archive, libmpc, https://ftp.gnu.org/gnu/mpc/mpc-$(VER_MPC).tar.gz)
$(call get_archive, libisl, http://isl.gforge.inria.fr/isl-$(VER_ISL).tar.bz2)
$(call get_archive, libexpat, https://github.com/libexpat/libexpat/releases/download/R_2_1_1/expat-$(VER_EXPAT).tar.bz2)
$(call get_archive, libelf, https://fossies.org/linux/misc/old/libelf-0.8.13.tar.gz)
$(call get_archive, libiconv, https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$(VER_LIBICONV).tar.gz)

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
	cd $(builddir)/libgmp && CPPFLAGS="-fexceptions" $(srcdir)/libgmp/gmp-$(VER_GMP)/configure \
		--host=$(T_HOST) \
		--build=$(T_BUILD) \
		--prefix=$(hostlibs)/usr \
		--enable-cxx \
		--disable-shared
	cd $(builddir)/libgmp && $(MAKE)
	cd $(builddir)/libgmp && $(MAKE) install
	$(stamp)

$(libmpfr):
	rm -rf $(builddir)/libmpfr
	mkdir -p $(builddir)/libmpfr
	cd $(builddir)/libmpfr && $(srcdir)/libmpfr/mpfr-$(VER_MPFR)/configure \
	--host=$(TC_HOST) \
	--build=$(TC_BUILD) \
	--prefix=$(hostlibs)/usr \
	--disable-shared \
	--with-gmp=$(hostlibs)/usr
	cd $(builddir)/libmpfr && $(MAKE)
	cd $(builddir)/libmpfr && $(MAKE) install
	$(stamp)

$(libmpfr): $(libgmp)

$(libmpc):
	@rm -rf $(buiddir)/libmpc
	@mkdir -p $(builddir)/libmpc
	@cd $(builddir)/libmpc && $(srcdir)/libmpc/mpc-$(VER_MPC)/configure \
	--host=$(TC_HOST) \
	--build=$(TC_BUILD) \
	--prefix=$(hostlibs)/usr \
	--disable-shared \
	--with-gmp=$(hostlibs)/usr \
	--with-mpfr=$(hostlibs)/usr
	cd $(builddir)/libmpc && $(MAKE)
	cd $(builddir)/libmpc && $(MAKE) install
	$(stamp)

$(libmpc): $(libmpfr)

$(libisl):
	rm -rf $(builddir)/libisl
	mkdir -p $(builddir)/libisl
	cd $(builddir)/libisl && $(srcdir)/libisl/isl-$(VER_ISL)/configure \
	--host=$(TC_HOST) \
	--build=$(TC_BUILD) \
	--prefix=$(hostlibs)/usr \
	--disable-shared \
	--with-gmp-prefix=$(hostlibs)/usr
	cd $(builddir)/libisl && $(MAKE)
	cd $(builddir)/libisl && $(MAKE) install
	$(stamp)

$(libisl): $(libgmp)
$(libisl): | $(libmpfr)

$(libexpat):
	rm -rf $(builddir)/libexpat
	mkdir -p $(builddir)/libexpat
	cd $(builddir)/libexpat && $(srcdir)/libexpat/expat-$(VER_EXPAT)/configure \
	--host=$(TC_HOST) \
	--build=$(TC_BUILD) \
	--prefix=$(hostlibs)/usr \
	--disable-shared
	cd $(builddir)/libexpat && $(MAKE)
	cd $(builddir)/libexpat && $(MAKE) install
	$(stamp)

$(libexpat): | $(libisl)

$(libelf):
	rm -rf $(builddir)/libelf
	mkdir -p $(builddir)/libelf
	cd $(builddir)/libelf && $(srcdir)/libelf/libelf-$(VER_LIBELF)/configure \
	--host=$(TC_HOST) \
	--build=$(TC_BUILD) \
	--prefix=$(hostlibs)/usr \
	--disable-shared
	cd $(builddir)/libelf && $(MAKE)
	cd $(builddir)/libelf && $(MAKE) install
	$(stamp)

$(libelf): | $(libexpat)

$(libiconv):
	rm -rf $(builddir)/libiconv
	mkdir -p $(builddir)/libiconv
	cd $(builddir)/libiconv && $(srcdir)/libiconv/libiconv-$(VER_LIBICONV)/configure \
	--host=$(TC_HOST) \
	--build=$(TC_BUILD) \
	--prefix=$(hostlibs)/usr \
	--disable-nls \
	--disable-shared
	cd $(builddir)/libiconv && $(MAKE)
	cd $(builddir)/libiconv && $(MAKE) install
	$(stamp)

$(libiconv): | $(libelf)