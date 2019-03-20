LAYER:=glibc-bootstrap
include $(DEFINE_LAYER)

glibc-configure:=$(LSTAMP)/glibc-configure
glibc-headers:=$(LSTAMP)/glibc-headers

$(L) += $(glibc-configure)
$(L) += $(glibc-headers)

DEPENDS += kernel-headers

$(call git_clone, glibc, https://github.com/bminor/glibc.git, glibc-2.27)

include $(BUILD_LAYER)

GLIBC_CONFIG:=--with-headers=$(TC_SYSROOT)/include --disable-multilib libc_cv_forced_unwind=yes

$(glibc-configure):
	mkdir -p $(builddir)/glibc
	cd $(builddir)/glibc && $(srcdir)/glibc/configure -v --prefix="" --build=$(TC_BUILD) --host=$(TC_TARGET) $(GLIBC_CONFIG)
	$(stamp)


$(glibc-headers):
	cd $(builddir)/glibc && $(MAKE) install_root=$(TC_SYSROOT) install-bootstrap-headers=yes install-headers
	cd $(builddir)/glibc && $(MAKE) csu/subdir_lib
	mkdir -p $(TC_SYSROOT)/lib
	cd $(builddir)/glibc && install csu/crt1.o csu/crti.o csu/crtn.o $(TC_SYSROOT)/lib
	$(TC_PREFIX)/bin/$(TC_TARGET)-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $(TC_SYSROOT)/lib/libc.so
	mkdir -p $(TC_SYSROOT)/include/gnu
	touch $(TC_SYSROOT)/include/gnu/stubs.h
	$(stamp)

$(glibc-headers): $(glibc-configure)