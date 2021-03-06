#
#  Automatically select layers
#

define select_layer
$(eval _select_top:=$(strip $(call select_file,$(TOP)/layers/$(1).mk,$(TOP)/layers/$(1)/layer.mk)))
$(eval _top:=$(shell test -e $(_select_top) && echo -n $(_select_top)))
$(eval _select_recipe:=$(strip $(call select_file,$(RECIPE)/layers/$(1).mk,$(RECIPE)/layers/$(1)/layer.mk)))
$(eval _recipe:=$(shell test -e $(_select_recipe) && echo -n $(_select_recipe)))
$(eval _select_layer:=$(strip $(call select_file,$(BASE)/layers/$(1).mk,$(BASE)/layers/$(1)/layer.mk)))
$(eval _layer:=$(shell test -e $(_select_layer) && echo -n $(_select_layer)))
$(eval _inc_layer:=$(or $(_top),$(_recipe),$(_layer)))
$(eval include $(_inc_layer))
endef

ifneq ($(BASE_RECIPE),)
$(eval BASE_INCLUDE:=$(BASE_RECIPE))
BASE_RECIPE:=
$(eval TOP_RECIPE:=$(RECIPE))
$(eval TOP_RECIPE_LAYERS:=$(LAYERS))
$(eval include $(BASE)/recipes/$(BASE_INCLUDE)/recipe.mk)

RECIPE:=$(TOP_RECIPE)
LAYERS:=$(TOP_RECIPE_LAYERS)

endif


$(foreach layer,$(LAYERS), \
$(eval $(call select_layer,$(layer))) \
)

LAYERS:=
