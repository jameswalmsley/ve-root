LAYER:=tools-systime
include $(DEFINE_LAYER)

systime:=$(ROOTFS)/usr/bin/systime

$(L) += $(systime)

include $(BUILD_LAYER)

$(systime):
	$(CROSS_COMPILE)gcc --sysroot=$(ROOTFS) $(basedir)/systime.c -o $(ROOTFS)/usr/bin/systime
