MAKEFILE_LIST:=$(filter-out $(lastword $(MAKEFILE_LIST)), $(MAKEFILE_LIST))
LBASE:=$(realpath $(dir $(lastword $(MAKEFILE_LIST))))
LFILE:=$(realpath $(lastword $(MAKEFILE_LIST)))

ifeq ($(LAYER),)
$(error ERROR: LAYER not defined in $(LFILE))
endif

$(eval L:=L_$(LAYER))
$(eval T:=T_$(LAYER))

LSTAMP:=$(STAMP)/$(L)
.PHONY: $(L)

$(eval BUILD_$(LAYER):=$(BUILD)/$(L))

$(eval BASE_$(LAYER):=$(LBASE))

$(eval SRC_$(LAYER):=$(SOURCE)/$(L))

$(eval depend_previous:=$(lastword $(recipe)))

$(eval recipe += $(L))

.PHONY: $(L).clean

define layer_clean_invalidate
.PHONY: $(L).invalidate $(L).i
$(L).invalidate $(L).i:
	rm -rf $$($(L))
ifeq ($(CONFIG_OVERLAYFS),y)
	@-umount -R $(OVERLAYFS)/$(L)/mnt 2> /dev/null; true
	@rm -rf $(OVERLAYFS)/$(L)
endif

.PHONY: $(L)._clean
$(L)._clean:
	rm -rf $(BUILD)/$(L)

$(L).clean: | $(L).invalidate
$(L).clean: | $(L)._clean
$(L).clean: builddir:=$(BUILD_$(LAYER))
$(L).clean: srcdir:=$(SRC_$(LAYER))
$(L).clean: basedir:=$(BASE_$(LAYER))
$(L).clean: overlaydir:=$(OVERLAYFS)/$(L)

endef

$(eval $(layer_clean_invalidate))

define layer_preamble
.PHONY: $(L).preamble
$(L).preamble:
	@echo "::group:: 🔨 Building Layer - $(L)"

endef

$(eval $(layer_preamble))


define layer_outro
.PHONY: $(L).outro
$(L).outro:
	@echo "::endgroup::"
endef

$(eval $(layer_outro))

DEPENDS:=
RUNAFTER:=
