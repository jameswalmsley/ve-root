LAYER:=copylibs
include $(DEFINE_LAYER)

copylibs:=$(TC_STAMP)/copylibs

$(L) += $(copylibs)

include $(BUILD_LAYER)


$(copylibs):
	$(RECIPE)/scripts/copylibs.sh $(TC_NATIVEDIR) $(TC_PREFIX)


