LAYER:=sysroot-package
include $(DEFINE_LAYER)

sysroot-package:=$(OUT)/sysroot.tar.gz

$(L) += $(sysroot-package)

DEPENDS += $(LAYERS_INCLUDED)

include $(BUILD_LAYER)

$(sysroot-package):
	tar cvzf $@ -C $(SYSROOT) .
