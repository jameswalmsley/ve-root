LAYER:=overlays
include $(DEFINE_LAYER)

enable-audio.dtbo:=$(BUILD)/$(L)/enable-audio.dtbo

$(L) += $(enable-audio.dtbo)


include $(BUILD_LAYER)


BOOTIMAGE_FILES += $(enable-audio.dtbo)

$(enable-audio.dtbo):
	mkdir -p $(dir $@)
	dtc -I dts -O dtb -qq $(RECIPE)/overlays/enable-audio.dtso -o $@

