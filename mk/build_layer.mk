$($(L)): | $(L).preamble
$($(L)): $(BUILD)/$(L)
$(BUILD)/$(L):
	mkdir -p $@


$(L).outro: | $($(L))
$(eval $(L) += $(L).outro)
$(eval $(L) += $(L).preamble)

ifeq ($(CONFIG_OVERLAYFS),y)
$($(L)): | $(L).overlay_mount
$(L).overlay_umount: | $($(L))
$(eval $(L) += $(L).overlay_umount)
endif

# Evaluates to:
# Recipe: kernel
# L_kernel: $(L_kernel)
$(eval $(L):$$($(L)))

# Usually a layer depends on its source file.
# This can be disabled by setting LAYER_NODEPEND_FILE:=y
ifneq ($(LAYER_NODEPEND_FILE),y)
$(eval $($(L)): $(LFILE))
endif

#
#  Layer DEPENDS and RUNAFTER.
#

$(foreach dep, $(DEPENDS), \
$(eval DEPENDS_$(L)+=$(dep)) \
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
	@echo "RECIPE:        $(RECIPE)"
	@$(foreach t,$($(L)) $($(T)),$(call show_target,$t);)
endef

$(eval $(layer_info))

define target_properties
$(foreach t, $($(L)) $($(T)),\
$(t): builddir:=$(BUILD)/$(L)$(\n)\
$(t): srcdir:=$(SOURCE)/$(L)$(\n)\
$(t): basedir:=$(LBASE)$(\n)\
$(t): overlaydir:=$(OVERLAYFS)/$(L)/mnt$(\n)\
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
	VEBASE=$(VEBASE) bash $(VEBASE)/mk/git/pull.sh $(g);\
	)
endef

git.pull: | $(L).git.pull

$(eval $(git_pull_layer))

define git_checkout_layer
.PHONY: $(L).git.checkout
$(L).git.checkout:
	@$(foreach g, $($(L)_git-repos),\
	VEBASE=$(VEBASE) bash $(VEBASE)/mk/git/checkout.sh $(g);\
	)

endef

git.checkout: | $(L).git.checkout

$(eval $(git_checkout_layer))

define git_fetch_layer
.PHONY: $(L).git.fetch
$(L).git.fetch:
	@$(foreach g, $($(L)_git-repos),\
	$(call git_repo_extract, $(g)) \
	VEBASE=$(VEBASE) bash $(VEBASE)/mk/git/fetch.sh $(g);\
	)
endef

git.fetch: | $(L).git.fetch

$(eval $(git_fetch_layer))

define git_submodule_update
.PHONY: $(L).git.submodule.update
$(L).git.submodule.update:
	@$(foreach g, $($(L)_git-repos),\
	VEBASE=$(VEBASE) bash $(VEBASE)/mk/git/submodule.sh $(g);\
	)
endef

git.submodule.update: | $(L).git.submodule.update

$(eval $(git_submodule_update))

define git_unshallow_layer
.PHONY: $(L).git.unshallow
$(L).git.unshallow:
	@$(foreach g, $($(L)_git-repos),\
	echo "unshallow: $(L)"; \
	VEBASE=$(VEBASE) bash $(VEBASE)/mk/git/unshallow.sh $(g);\
	)
endef

git.unshallow: | $(L).git.unshallow

$(eval $(git_unshallow_layer))

define git_status_layer
.PHONY: $(L).git.status
$(L).git.status:
	@$(foreach g, $($(L)_git-repos),\
	VEBASE=$(VEBASE) bash $(VEBASE)/mk/git/status.sh $(g);\
	)
endef

git.status: | $(L).git.status

$(eval $(git_status_layer))

define git_describe_layer
.PHONY: $(L).git.describe
$(L).git.describe:
	@$(foreach g, $($(L)_git-repos),\
	VEBASE=$(VEBASE) bash $(VEBASE)/mk/git/describe.sh $(g);\
	)
endef

git.describe: | $(L).git.describe

$(eval $(git_describe_layer))

define git_freeze
.PHONY: $(L).git.freeze
$(L).git.freeze:
	@$(foreach g, $($(L)_git-repos),\
	VEBASE=$(VEBASE) bash $(VEBASE)/mk/git/freeze.sh $(g);\
	)
endef

git.freeze: | $(L).git.freeze

$(eval $(git_freeze))

define git_rev-parse_head_layer
.PHONY: $(L).git.rev-parse.head
$(L).git.rev-parse.head:
	@$(foreach g, $($(L)_git-repos),\
	VEBASE=$(VEBASE) bash $(VEBASE)/mk/git/rev-parse.head.sh $(g);\
	)
endef

git.rev-parse.head: | $(L).git.rev-parse.head

$(eval $(git_rev-parse_head_layer))

ifeq ($(CONFIG_OVERLAYFS),y)
$(eval $(L)_OVERLAY_LOWERDIRS:=$(subst $(space),:,$(strip $(patsubst %,$(OVERLAYFS)/L_%/upper,$(call reverse,$(LAYERS_INCLUDED))) $(OVERLAYFS)/L_base/upper)))

define overlay_mount
.PHONY:$(L).overlay_mount
$(L).overlay_mount:
	@mkdir -p $(OVERLAYFS)/L_base/upper
	@mkdir -p $(OVERLAYFS)/$(L)/mnt
	@mkdir -p $(OVERLAYFS)/$(L)/upper
	@mkdir -p $(OVERLAYFS)/$(L)/workdir
	@-umount -R $(OVERLAYFS)/$(L)/mnt 2> /dev/null; true
	mount -t overlay overlay -olowerdir=$($(L)_OVERLAY_LOWERDIRS),upperdir=$(OVERLAYFS)/$(L)/upper,workdir=$(OVERLAYFS)/$(L)/workdir $(OVERLAYFS)/$(L)/mnt

endef
$(eval $(overlay_mount))

define overlay_umount
.PHONY:$(L).overlay_umount
$(L).overlay_umount:
	@-umount -R $(OVERLAYFS)/$(L)/mnt

endef

$(eval $(overlay_umount))

define overlay_chroot
.PHONY:$(L).chroot
$(L).chroot: | $(L).overlay_mount
	arch-chroot $(OVERLAYFS)/$(L)/mnt/$(CONFIG_OVERLAYFS_ROOTFS_PATH)
	umount -R $(OVERLAYFS)/$(L)/mnt

endef

$(eval $(overlay_chroot))
endif

$(eval LAYERS_INCLUDED += $(LAYER))

LAYER:=
LAYER_NODEPEND_FILE:=
