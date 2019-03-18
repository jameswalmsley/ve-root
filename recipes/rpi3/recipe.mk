#
# RPI3 Recipe
#
include $(DEFINE_RECIPE)



#
# Include all required layers.
#
include $(RECIPE)/layers/bootloader.mk
include $(RECIPE)/layers/kernel.mk
include $(LAYERS)/debian-rootfs/layer.mk
include $(RECIPE)/layers/kernel-modules.mk
include $(RECIPE)/layers/debian-customise.mk
include $(RECIPE)/layers/rpi-firmware.mk
include $(RECIPE)/layers/initramfs-base.mk
include $(RECIPE)/layers/bootramfs.mk
include $(RECIPE)/layers/bootimage.mk


