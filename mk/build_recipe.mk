#
#  Automatically select layers
#

define select_layer
$(eval _select_top:=$(strip $(call select_file,$(TOP)/layers/$(1).mk,$(TOP)/layers/$(1)/$(1).mk)))
$(eval _top:=$(shell test -e $(_select_top) && $(ECHO) -n $(_select_top)))
$(eval _select_recipe:=$(strip $(call select_file,$(RECIPE)/layers/$(1).mk,$(RECIPE)/layers/$(1)/$(1).mk)))
$(eval _recipe:=$(shell test -e $(_select_recipe) && $(ECHO) -n $(_select_recipe)))
$(eval _select_layer:=$(strip $(call select_file,$(VEBASE)/layers/$(1).mk,$(VEBASE)/layers/$(1)/$(1).mk)))
$(eval _layer:=$(shell test -e $(_select_layer) && $(ECHO) -n $(_select_layer)))
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


define eval_layer_deps
$(foreach dep,$(2), \
$(eval $$(L_$(1)): $$(L_$(dep))) \
)
endef

define eval_layer_depends
$(call eval_layer_deps,$(1),$(DEPENDS_L_$(1)))
endef

$(foreach layer,$(LAYERS), \
$(eval $(call eval_layer_depends,$(layer))) \
)

LAYERS:=
