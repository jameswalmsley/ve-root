LAYER:=libgcc
include $(DEFINE_LAYER)

libgcc:=$(LSTAMP)/libgcc

$(L) += $(libgcc)


DEPENDS += gcc-bootstrap
DEPENDS += glibc-bootstrap

include $(BUILD_LAYER)


$(libgcc):
	cd $(BUILD_gcc-bootstrap)/gcc && $(MAKE) all-target-libgcc
	cd $(BUILD_gcc-bootstrap)/gcc && $(MAKE) install-target-libgcc
	$(stamp)

