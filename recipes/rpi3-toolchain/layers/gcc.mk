LAYER:=gcc
include $(DEFINE_LAYER)

gcc-configure:=$(LSTAMP)/gcc-configure
gcc:=$(LSTAMP)/gcc

$(L) += $(gcc-configure)
$(L) += $(gcc)

DEPENDS += glibc
DEPENDS += gcc-bootstrap

include $(BUILD_LAYER)


$(gcc-configure):
	cd $(BUILD_gcc-bootstrap)/gcc && $(SRC_gcc-bootstrap)/gcc/configure $(GCC_CONFIG) \
	--host=$(TC_HOST) --build=$(TC_BUILD) --target=$(TC_TARGET) --prefix=$(TC_PREFIX)
	$(stamp)


$(gcc):
	mkdir -p $(TC_SYSROOT)/usr/include
	cd $(BUILD_gcc-bootstrap)/gcc && $(MAKE)
	cd $(BUILD_gcc-bootstrap)/gcc && $(MAKE) install-strip
	$(stamp)

$(gcc): $(gcc-configure)

