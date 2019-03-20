LAYER:=strip
include $(DEFINE_LAYER)

strip-host:=$(LSTAMP)/strip-host
strip-target:=$(LSTAMP)/strip-target

$(L) += $(strip-host)
$(L) += $(strip-target)

include $(BUILD_LAYER)

$(strip-host):
	$(RECIPE)/scripts/strip-host.sh $(TC_PREFIX)/bin
	$(RECIPE)/scripts/strip-host.sh $(TC_PREFIX)/$(TC_TARGET)/bin
	$(RECIPE)/scripts/strip-host.sh $(TC_PREFIX)/lib/gcc/$(TC_TARGET)/*/
	$(stamp)


TARGET_LIBS += $(TC_PREFIX)/$(TC_TARGET)/lib
TARGET_LIBS += $(TC_PREFIX)/$(TC_TARGET)/lib64
TARGET_LIBS += $(TC_PREFIX)/$(TC_TARGET)/libexec
TARGET_LIBS += $(TC_PREFIX)/lib/gcc/$(TC_TARGET)/*

define strip_target
	@echo $(1)
	$(RECIPE)/scripts/strip-target.sh $(TC_TARGET) $(1) "-name *.a"
	$(RECIPE)/scripts/strip-target.sh $(TC_TARGET) $(1) "-name *.o"
	$(RECIPE)/scripts/strip-target.sh $(TC_TARGET) $(1) "-name *.so"
	$(RECIPE)/scripts/strip-target.sh $(TC_TARGET) $(1) "-executable -type f"

endef

$(strip-target):
	$(foreach lib,$(TARGET_LIBS),$(call strip_target,$(lib)))
	$(stamp)
	