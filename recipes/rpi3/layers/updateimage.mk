LAYER:=updateimage
include $(DEFINE_LAYER)

updateimage:=$(LSTAMP)/update-image

$(L) += $(updateimage)

DEPENDS += bootloader-updateimage
DEPENDS += rootfs-ext4-image

include $(BUILD_LAYER)

UPDATE:=$(OUT)/update

$(updateimage):
	rm -rf $(UPDATE)
	mkdir -p $(UPDATE)
	rsync -av $(bootloader-updateimage.fit) $(UPDATE)/
	rsync -av $(rootfs-ext4-image.gz) $(UPDATE)/system.img.gz
	$(stamp)
