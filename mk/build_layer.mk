# Evaluates to:
# Recipe: kernel
# L_kernel: $(L_kernel)
$(eval $(L):$$($(L)))

#
#  Layer DEPENDS and RUNAFTER.
#
define check_deps
$(eval check:=$(1))
ifeq ($(check),"")
$(eval error_info += $(2))
all: | dependency_error
endif
endef


$(foreach dep, $(DEPENDS), \
$(eval $$($(L)): $$(L_$(dep))) \
$(eval $(call check_deps,"$$(L_$(dep))",$(L)::$(dep))) \
)
#
# Serialise each layer added.
#

ifneq ($(ENABLE_PARALLEL_LAYERS),y)

define serialise_layers
RUNAFTER += $(patsubst L_%,%,$(lastword $(filter-out $(lastword $(recipe)),$(recipe))))
endef

$(eval $(serialise_layers))

endif

define check_rundeps
$(eval check:=$(1))
ifeq ($(check),"")
$(eval error_info += $(2))
all: | rundep_error
endif
endef

$(foreach dep, $(RUNAFTER), \
$(eval $$($(L)): | $$(L_$(dep))) \
$(eval $(call check_rundeps,"$$(L_$(dep))",$(L)::$(dep))) \
)


#
# L_layername.info
#
define show_target
	echo "TARGETS +=      $(1:$(BASE)/%=%)"
endef

define layer_info
$(L).info:
	@echo "DEPENDS:       $(DEPENDS)"
	@echo "RUNAFTER:      $(RUNAFTER)"
	@$(foreach t,$($(L)),$(call show_target,$t);)
endef

$(eval $(layer_info))

define target_properties
$(foreach t, $($(L)),\
	$(t): builddir:=$(BUILD)/$(L)$(\n)\
$(t): srcdir:=$(SOURCE)/$(L)$(\n)\
)

endef

$(eval $(target_properties))

