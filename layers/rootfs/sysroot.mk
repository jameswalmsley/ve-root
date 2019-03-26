LAYER:=sysroot
include $(DEFINE_LAYER)


sysroot:=$(LSTAMP)/sysroot

$(L) += $(sysroot)


include $(BUILD_LAYER)



SYSROOT:=$(OUT)/sysroot

SYSROOT_DIRS += usr/lib
SYSROOT_DIRS += usr/include

$(sysroot):
	rm -rf $(SYSROOT)
	mkdir -p $(SYSROOT)
	$(foreach dir,$(SYSROOT_DIRS), \
	mkdir -p $(SYSROOT)/$(dir) $(\n) \
	rsync -av $(ROOTFS)/$(dir)/* $(SYSROOT)/$(dir)/ $(\n) \
	)
	$(stamp)