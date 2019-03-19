MAKEFILE_LIST:=$(filter-out $(lastword $(MAKEFILE_LIST)), $(MAKEFILE_LIST))
LBASE:=$(shell readlink -f $(dir $(lastword $(MAKEFILE_LIST))))

$(eval L:=L_$(LAYER))
LSTAMP:=$(STAMP)/$(L)
.PHONY: $(L)

$(eval B_$(LAYER):=$(LBASE))

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

