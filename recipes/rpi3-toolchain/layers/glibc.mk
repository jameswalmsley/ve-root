LAYER:=glibc
include $(DEFINE_LAYER)

glibc:=$(LSTAMP)/glibc

$(L) += $(glibc)

DEPENDS += libgcc

include $(BUILD_LAYER)

$(glibc):
	cd $(BUILD_glibc-bootstrap)/glibc && $(MAKE)
	cd $(BUILD_glibc-bootstrap)/glibc && $(MAKE) install_root=$(TC_SYSROOT) install
	# Replace linker scripts! - ensure relocatable.
	sed -i 's/\/lib\///g' $(TC_SYSROOT)/lib/libc.so
	sed -i 's/\/lib\///g' $(TC_SYSROOT)/lib/libpthread.so
	$(stamp)


