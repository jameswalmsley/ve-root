LAYER:=libgcc
include $(DEFINE_LAYER)

libgcc:=$(TC_STAMP)/libgcc

$(L) += $(libgcc)


DEPENDS += gcc-bootstrap
DEPENDS += glibc-bootstrap

include $(BUILD_LAYER)


$(libgcc):
	cd $(BUILD_gcc-bootstrap)/$(TC_HOST)/gcc && $(MAKE) all-target-libgcc
	cd $(BUILD_gcc-bootstrap)/$(TC_HOST)/gcc && $(MAKE) install-target-libgcc
	$(stamp)

