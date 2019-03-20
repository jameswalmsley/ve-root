LAYER:=rootfs-tarball
include $(DEFINE_LAYER)

rootfs-tarball:=$(OUT)/rootfs.tar

$(L) += $(rootfs-tarball)

include $(BUILD_LAYER)

$(rootfs-tarball):
	tar cvf $@ -C $(ROOTFS) .
