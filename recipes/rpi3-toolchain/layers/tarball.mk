LAYER:=tarball

include $(DEFINE_LAYER)

tarball:=$(BUILD_tarball)/$(TC_HOST)-$(TC_TARGET).tar
7z:=$(OUT)/$(TC_HOST)-$(TC_TARGET).7z

$(L) += $(tarball)
$(L) += $(7z)

include $(BUILD_LAYER)

$(tarball):
	mkdir -p $(dir $@)
	tar cvf $@ -C $(OUT)/$(TC_HOST)/$(TC_TARGET) .

$(7z):
	7z a $@ -mx9 -mmt -md29 -ms=on -myx=9 -mfb=273 $(tarball)

$(7z): $(tarball)
