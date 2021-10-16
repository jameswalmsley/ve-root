LAYER:=glibc-bootstrap
include $(DEFINE_LAYER)

glibc-configure:=$(TC_STAMP)/glibc-configure
glibc-headers:=$(TC_STAMP)/glibc-headers

$(L) += $(glibc-configure)
$(L) += $(glibc-headers)

DEPENDS += kernel-headers

$(call git_clone, glibc, https://github.com/bminor/glibc.git, release/2.27/master)

include $(BUILD_LAYER)

GLIBC_CONFIG:=--with-headers=$(TC_SYSROOT)/include --disable-multilib libc_cv_forced_unwind=yes

ifeq ($(TC_NATIVE),y)
TC_HOST:=$(TC_BUILD)
endif
$(glibc-configure):
	rm -rf $(builddir)/$(TC_HOST)/glibc
	mkdir -p $(builddir)/$(TC_HOST)/glibc
	cd $(builddir)/$(TC_HOST)/glibc && $(srcdir)/glibc/configure -v --prefix="" --build=$(TC_HOST) --host=$(TC_TARGET) $(GLIBC_CONFIG)
	$(stamp)


$(glibc-headers):
ifneq ($(TC_NATIVE),y)
	-ln -s $(TC_NATIVEDIR)/bin/$(TC_TARGET)-gcc $(TC_PREFIX)/bin/$(TC_TARGET)-gcc
endif
	cd $(builddir)/$(TC_HOST)/glibc && $(MAKE) install_root=$(TC_SYSROOT) install-bootstrap-headers=yes install-headers
	cd $(builddir)/$(TC_HOST)/glibc && $(MAKE) csu/subdir_lib
	mkdir -p $(TC_SYSROOT)/lib
	cd $(builddir)/$(TC_HOST)/glibc && install csu/crt1.o csu/crti.o csu/crtn.o $(TC_SYSROOT)/lib
	$(TC_PREFIX)/bin/$(TC_TARGET)-gcc -nostdlib -nostartfiles -shared -x c /dev/null -o $(TC_SYSROOT)/lib/libc.so
	mkdir -p $(TC_SYSROOT)/include/gnu
	touch $(TC_SYSROOT)/include/gnu/stubs.h
ifneq ($(TC_NATIVE),y)
	rm $(TC_PREFIX)/bin/$(TC_TARGET)-gcc
endif
	$(stamp)

$(glibc-headers): $(glibc-configure)
