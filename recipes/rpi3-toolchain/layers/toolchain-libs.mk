LAYER:=toolchain-libs
include $(DEFINE_LAYER)

zlib:=$(TC_STAMP)/zlib
libgmp:=$(TC_STAMP)/libgmp
libmpfr:=$(TC_STAMP)/libmpfr
libmpc:=$(TC_STAMP)/libmpc
libisl:=$(TC_STAMP)/libisl
libexpat:=$(TC_STAMP)/libexpat

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
$(call git_clone,   libisl, https://github.com/Meinersbur/isl.git, isl-$(VER_ISL))
$(call get_archive, libexpat, https://github.com/libexpat/libexpat/releases/download/R_2_1_1/expat-$(VER_EXPAT).tar.bz2)
$(call get_archive, libelf, https://fossies.org/linux/misc/old/libelf-0.8.13.tar.gz)
$(call get_archive, libiconv, https://ftp.gnu.org/pub/gnu/libiconv/libiconv-$(VER_LIBICONV).tar.gz)

include $(BUILD_LAYER)

$(zlib):
	rm -rf $(builddir)/$(TC_HOST)/zlib
	mkdir -p $(builddir)/$(TC_HOST)/zlib
	cp -r $(srcdir)/zlib/* $(builddir)/$(TC_HOST)/zlib/
	cd $(builddir)/$(TC_HOST)/zlib && $(TC_HOSTENV) ./configure --static --prefix=$(hostlibs)/usr
	cd $(builddir)/$(TC_HOST)/zlib && $(MAKE)
	cd $(builddir)/$(TC_HOST)/zlib && $(MAKE) install
	$(stamp)

$(libgmp):
	rm -rf $(builddir)/$(TC_HOST)/libgmp
	mkdir -p $(builddir)/$(TC_HOST)/libgmp
	cd $(builddir)/$(TC_HOST)/libgmp && CPPFLAGS="-fexceptions" $(srcdir)/libgmp/gmp-$(VER_GMP)/configure \
		--host=$(TC_HOST) \
		--build=$(TC_BUILD) \
		--prefix=$(hostlibs)/usr \
		--enable-cxx \
		--disable-shared
	cd $(builddir)/$(TC_HOST)/libgmp && $(MAKE)
	cd $(builddir)/$(TC_HOST)/libgmp && $(MAKE) install
	$(stamp)

$(libmpfr):
	rm -rf $(builddir)/$(TC_HOST)/libmpfr
	mkdir -p $(builddir)/$(TC_HOST)/libmpfr
	cd $(builddir)/$(TC_HOST)/libmpfr && $(srcdir)/libmpfr/mpfr-$(VER_MPFR)/configure \
	--host=$(TC_HOST) \
	--build=$(TC_BUILD) \
	--prefix=$(hostlibs)/usr \
	--disable-shared \
	--with-gmp=$(hostlibs)/usr
	cd $(builddir)/$(TC_HOST)/libmpfr && $(MAKE)
	cd $(builddir)/$(TC_HOST)/libmpfr && $(MAKE) install
	$(stamp)

$(libmpfr): $(libgmp)

$(libmpc):
	@rm -rf $(buiddir)/$(TC_HOST)/libmpc
	@mkdir -p $(builddir)/$(TC_HOST)/libmpc
	@cd $(builddir)/$(TC_HOST)/libmpc && $(srcdir)/libmpc/mpc-$(VER_MPC)/configure \
	--host=$(TC_HOST) \
	--build=$(TC_BUILD) \
	--prefix=$(hostlibs)/usr \
	--disable-shared \
	--with-gmp=$(hostlibs)/usr \
	--with-mpfr=$(hostlibs)/usr
	cd $(builddir)/$(TC_HOST)/libmpc && $(MAKE)
	cd $(builddir)/$(TC_HOST)/libmpc && $(MAKE) install
	$(stamp)

$(libmpc): $(libmpfr)

$(libisl):
	rm -rf $(builddir)/$(TC_HOST)/libisl
	mkdir -p $(builddir)/$(TC_HOST)/libisl
	cd $(srcdir)/libisl && ./autogen.sh
	cd $(builddir)/$(TC_HOST)/libisl && $(srcdir)/libisl/configure \
	--host=$(TC_HOST) \
	--build=$(TC_BUILD) \
	--prefix=$(hostlibs)/usr \
	--disable-shared \
	--with-gmp-prefix=$(hostlibs)/usr
	cd $(builddir)/$(TC_HOST)/libisl && $(MAKE)
	cd $(builddir)/$(TC_HOST)/libisl && $(MAKE) install
	$(stamp)

$(libisl): $(libgmp)
$(libisl): | $(libmpfr)

$(libexpat):
	rm -rf $(builddir)/$(TC_HOST)/libexpat
	mkdir -p $(builddir)/$(TC_HOST)/libexpat
	cd $(builddir)/$(TC_HOST)/libexpat && $(srcdir)/libexpat/expat-$(VER_EXPAT)/configure \
	--host=$(TC_HOST) \
	--build=$(TC_BUILD) \
	--prefix=$(hostlibs)/usr \
	--disable-shared
	cd $(builddir)/$(TC_HOST)/libexpat && $(MAKE)
	cd $(builddir)/$(TC_HOST)/libexpat && $(MAKE) install
	$(stamp)

$(libexpat): | $(libisl)

$(libelf):
	rm -rf $(builddir)/$(TC_HOST)/libelf
	mkdir -p $(builddir)/$(TC_HOST)/libelf
	cd $(builddir)/$(TC_HOST)/libelf && $(srcdir)/libelf/libelf-$(VER_LIBELF)/configure \
	--host=$(TC_HOST) \
	--build=$(TC_BUILD) \
	--prefix=$(hostlibs)/usr \
	--disable-shared
	cd $(builddir)/$(TC_HOST)/libelf && $(MAKE)
	cd $(builddir)/$(TC_HOST)/libelf && $(MAKE) install
	$(stamp)

$(libelf): | $(libexpat)

$(libiconv):
	rm -rf $(builddir)/$(TC_HOST)/libiconv
	mkdir -p $(builddir)/$(TC_HOST)/libiconv
	cd $(builddir)/$(TC_HOST)/libiconv && $(srcdir)/libiconv/libiconv-$(VER_LIBICONV)/configure \
	--host=$(TC_HOST) \
	--build=$(TC_BUILD) \
	--prefix=$(hostlibs)/usr \
	--disable-nls \
	--disable-shared
	cd $(builddir)/$(TC_HOST)/libiconv && $(MAKE)
	cd $(builddir)/$(TC_HOST)/libiconv && $(MAKE) install
	$(stamp)

$(libiconv): | $(libelf)
