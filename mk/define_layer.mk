$(eval L:=L_$(LAYER))
LSTAMP:=$(STAMP)/$(L)
.PHONY: $(L)

$(eval S_$(LAYER):=$(SOURCE)/$(L))

$(eval depend_previous:=$(lastword $(recipe)))

$(eval recipe += $(L))

.PHONY: $(L).clean


define layer_invalidate
.PHONY: $(L).invalidate
$(L).invalidate:
	rm -rf $$($(L))

$(L).clean: | $(L).invalidate
endef

$(eval $(layer_invalidate))

DEPENDS:=
RUNAFTER:=

#$(eval DEPENDS += $(depend_previous))
