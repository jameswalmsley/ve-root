#
#  VE-Root - An embedded rootfs build-tool.
#
#  (C) 2019 Vital Element Solutions Ltd.
#
#  Author: James Walmsley <james@vitalelement.co.uk>
#
BASE:=$(shell readlink -f $(dir $(lastword $(MAKEFILE_LIST))))
include $(BASE)/mk/environment.mk

ifdef CONFIG_RECIPE

.PHONY:recipe
all: recipe

.PHONY:source-checkout

include $(BASE)/recipes/$(CONFIG_RECIPE)/recipe.mk

define show_layer
	echo "LAYER +=        $(1)"
endef

info:
	@echo "BASE:           $(BASE)"
	@echo "RECIPE:         $(RECIPE)"
	@echo "LAYERS:         $(LAYERS)"
	@echo "TOP:            $(TOP)"
	@echo "OUT:            $(OUT)"
	@echo "ROOTFS:         $(ROOTFS)"
	@echo "ENABLE_DEV:     $(ENABLE_DEV)"
	@$(foreach l,$(recipe),$(call show_layer,$l);)


recipe: $(recipe)
$(recipe): | $(source-checkout)

source-checkout: | $(source-checkout)

#
# Ensure all layer targets are dependent on source-checkout.
#
$(foreach layer,$(recipe), \
$(eval $$($(layer)): | source-checkout)\
)

clean:
	$(foreach layer,$(recipe), \
	$(MAKE) $(layer).clean $(\n)\
	)

mrproper:
	rm -rf $(OUT)

endif


.PHONY: docker
docker:
	cd $(BASE)/docker && docker-compose run -e ENABLE_DEV=y rootbuilder
