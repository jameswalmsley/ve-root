LAYER:=gcc-bootstrap
include $(DEFINE_LAYER)

gcc-bootstrap-configure:=$(LSTAMP)/gcc-bootstrap-configure
gcc-bootstrap:=$(LSTAMP)/gcc-bootstrap
libgcc:=$(LSTAMP)/libgcc

$(L) += $(gcc-bootstrap-configure)
$(L) += $(gcc-bootstrap)

DEPENDS += toolchain-libs
RUNAFTER += binutils

$(call git_clone, gcc, https://github.com/gcc-mirror/gcc.git, gcc-7_3_0-release)

include $(BUILD_LAYER)

#
GCC_ARCH_CONFIG:=--with-cpu=cortex-a53
#--disable-libmudflap --disable-libgomp --without-ppl --without-cloog --disable-libstdcxx-pch

GCC_OPTIONS += "--with-host-libstdcxx=-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm"
GCC_OPTIONS += --with-gmp=$(hostlibs)/usr
GCC_OPTIONS += --with-mpfr=$(hostlibs)/usr
GCC_OPTIONS += --with-mpc=$(hostlibs)/usr
GCC_OPTIONS += --with-isl=$(hostlibs)/usr
GCC_OPTIONS += --with-libelf=$(hostlibs)/usr
ifeq ($(BUILD_WINDOWS),y)
GCC_OPTIONS += --with-libiconv-prefix=$(hostlibs)/usr
endif

GCC_BOOTSTRAP_CONFIG += $(GCC_OPTIONS)
GCC_BOOTSTRAP_CONFIG += --enable-languages=c,c++
GCC_BOOTSTRAP_CONFIG += $(GCC_ARCH_CONFIG)
GCC_BOOTSTRAP_CONFIG += --disable-multilib
GCC_BOOTSTRAP_CONFIG += --disable-nls
GCC_BOOTSTRAP_CONFIG += --libexecdir=$(TC_PREFIX)/lib
GCC_BOOTSTRAP_CONFIG += --with-sysroot=$(TC_SYSROOT)

GCC_CONFIG += $(GCC_OPTIONS)
GCC_CONFIG += --enable-languages=c,c++
GCC_CONFIG += $(GCC_ARCH_CONFIG)
GCC_CONFIG += --disable-multilib
GCC_CONFIG += --disable-nls
GCC_CONFIG += --libexecdir=$(TC_PREFIX)/lib
GCC_CONFIG += --with-sysroot=$(TC_SYSROOT)

$(gcc-bootstrap-configure):
	rm -rf $(builddir)/gcc
	mkdir -p $(builddir)/gcc
	cd $(builddir)/gcc && $(srcdir)/gcc/configure $(GCC_BOOTSTRAP_CONFIG) \
	--host=$(TC_HOST) \
	--build=$(TC_BUILD) \
	--target=$(TC_TARGET) \
	--prefix=$(TC_PREFIX)
	$(stamp)

$(gcc-bootstrap):
	mkdir -p $(TC_SYSROOT)/usr/include
	cd $(builddir)/gcc && $(MAKE) all-gcc
	cd $(builddir)/gcc && $(MAKE) install-gcc
	$(stamp)

$(gcc-bootstrap): $(gcc-bootstrap-configure)
