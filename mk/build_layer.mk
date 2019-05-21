# Evaluates to:
# Recipe: kernel
# L_kernel: $(L_kernel)
$(eval $(L):$$($(L)))

$(eval $($(L)): $(LFILE))

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
	@echo "LSTAMP:        $(LSTAMP)"
	@$(foreach t,$($(L)) $($(T)),$(call show_target,$t);)
endef

$(eval $(layer_info))

define target_properties
$(foreach t, $($(L)) $($(T)),\
$(t): builddir:=$(BUILD)/$(L)$(\n)\
$(t): srcdir:=$(SOURCE)/$(L)$(\n)\
$(t): basedir:=$(LBASE)$(\n)\
ifeq ($(filter $(LAYER),$(ROOTFS_DEPENDS)),)$(\n)\
$(t): RECIPE:=$(RECIPE)$(\n)\
else$(\n)\
$(t): RECIPE:=$(TOP_RECIPE)$(\n)\
endif $(\n)\
)

endef

$(eval $(target_properties))

_git-status:=**** :: 

define git_pull_layer
.PHONY: $(L).git.pull
$(L).git.pull:
	@$(foreach g, $($(L)_git-repos),\
	echo "$(_git-status)Pulling: $(g)";cd $(g) && git pull;\
	)
endef

git.pull: | $(L).git.pull

$(eval $(git_pull_layer))

define git_fetch_layer
.PHONY: $(L).git.fetch
$(L).git.fetch:
	@$(foreach g, $($(L)_git-repos),\
	echo "$(_git-status)Fetching: $(g)"; cd $(g) && git fetch;\
	)
endef

git.fetch: | $(L).git.fetch

$(eval $(git_fetch_layer))

define git_unshallow_layer
.PHONY: $(L).git.unshallow
$(L).git.unshallow:
	@$(foreach g, $($(L)_git-repos),\
	echo "$(_git-status)Unshallowing: $(g)"; cd $(g) && git fetch --unshallow; cd $(g) && git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"\
	)
endef

git.unshallow: | $(L).git.unshallow

$(eval $(git_unshallow_layer))

define git_status_layer
.PHONY: $(L).git.status
$(L).git.status:
	@$(foreach g, $($(L)_git-repos),\
	echo "$(_git-status)Git Status: $(g)"; cd $(g) && git status;\
	)
endef

git.status: | $(L).git.status

$(eval $(git_status_layer))
