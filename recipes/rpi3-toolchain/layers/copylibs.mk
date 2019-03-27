LAYER:=copylibs
include $(DEFINE_LAYER)

#
#	The non-native Windows mingw32 build of libgcc doesn't quite work.
#	Hack has always been to not build the libs natively.
#

copylibs:=$(TC_STAMP)/copylibs

$(L) += $(copylibs)

include $(BUILD_LAYER)


$(copylibs):
	$(RECIPE)/scripts/copylibs.sh $(TC_NATIVEDIR) $(TC_PREFIX)
	$(stamp)
