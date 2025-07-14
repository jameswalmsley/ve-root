-include $(BASE)/.config
all:

include $(VEBASE)/configs/configs.mk


ifndef CONFIG_RECIPE
all: configs
info:
	@echo "You MUST configure the build system."

else

include $(VEBASE)/mk/os.mk
#
# Variables
#

R?=$(CONFIG_RECIPE)

_VARIANT:=
VARIANT:=
ifneq ($(CONFIG_VARIANT),)
VARIANT:=$(CONFIG_VARIANT)
_VARIANT:=/$(CONFIG_VARIANT)
endif

OUT:=$(CURDIR)/out/$(R)$(_VARIANT)
TOP:=$(BASE)/recipes/$(R)
SOURCE:=$(BASE)/sources/$(R)
BUILD:=$(OUT)/build
STAMP:=$(OUT)/.stamp
ROOTFS:=$(OUT)/rootfs
BOOT:=$(OUT)/boot
OVERLAYFS:=$(OUT)/overlayfs

DEFINE_RECIPE:=$(VEBASE)/mk/define_recipe.mk
BUILD_RECIPE:=$(VEBASE)/mk/build_recipe.mk
DEFINE_LAYER:=$(VEBASE)/mk/define_layer.mk
BUILD_LAYER:=$(VEBASE)/mk/build_layer.mk

ifndef WINDOWS
ifeq ($(UID),)
USER_ID:=$(shell id -u)
endif

ifeq ($(GID),)
GROUP_ID:=$(shell id -g)
endif
endif

define \n


endef

null:=
space:= $(null) #
comma:= ,


define touch_stamp
	mkdir -p $(dir $@) && touch $@
endef

stamp=$(call touch_stamp)
reverse = $(if $(wordlist 2,2,$(1)),$(call reverse,$(wordlist 2,$(words $(1)),$(1))) $(firstword $(1)),$(1))

#
# $(call select_file,try,default)
#
define select_file
	$(if $(wildcard $(1)),$(1),$(2))
endef

#
# Git checkouts.
# Layers become build-dependent on their git sources changing.
#
# E.g. a git checkout -b branch will cause layer to re-build.
#
define git_clone_impl

$(eval GIT_$(L)_$(strip $(1))?=$(strip $(3)))
$(eval SRCDEST:=$(SOURCE)/$(L)/$(strip $(1))/.git/index)
$(SRCDEST):
	@echo "Cloning"
ifeq ("$(wildcard $(SRCDEST))","")
	git init $(SOURCE)/$(L)/$(strip $(1))
	cd $(SOURCE)/$(L)/$(strip $(1)) && git remote add origin $(strip $(2))
	cd $(SOURCE)/$(L)/$(strip $(1)) && git fetch --depth 1 origin $(GIT_$(L)_$(strip $(1))) || git fetch origin
	cd $(SOURCE)/$(L)/$(strip $(1)) && git checkout $(GIT_$(L)_$(strip $(1))) || git checkout FETCH_HEAD
	cd $(SOURCE)/$(L)/$(strip $(1)) && git submodule update --init --recursive
ifneq ($(WINDOWS),y)
	chown -R $(USER_ID):$(GROUP_ID) $(SOURCE)/$(L)/$(strip $(1))
endif
endif


source-checkout += $(SRCDEST)

$(eval $$($(L)): $(SRCDEST))

$(L)_git-repos += $(SOURCE)/$(L)/$(strip $(1)):$(GIT_$(L)_$(strip $(1)))

endef

define git_clone
	$(eval $(git_clone_impl))
endef

#
# Archive checkouts
#
#
#
WGET_FLAGS:=
ifdef NONINTERACTIVE
WGET_FLAGS:=-nv
endif

define get_archive_impl
$(eval SRCDEST:=$(SOURCE)/$(L)/$(strip $(1))/$(notdir $(strip $(2))))
$(SRCDEST):
	@echo "Fetching $$@"
	mkdir -p $(SOURCE)/$(L)/$(strip $(1))
	wget $(WGET_FLAGS) -O $$@ $(2)
	tar xvf $$@ -C $(SOURCE)/$(L)/$(strip $(1))


source-checkout += $(SRCDEST)

$$($(L)): $(SRCDEST)

endef

define get_archive_dl_impl
$(eval SRCDEST:=$(SOURCE)/$(L)/$(strip $(1))/$(notdir $(strip $(2))))
$(SRCDEST):
	@echo "Fetching $$@"
	mkdir -p $(SOURCE)/$(L)/$(strip $(1))
	wget $(WGET_FLAGS) -O $$@ $(2)

source-checkout += $(SRCDEST)

$$($(L)): $(SRCDEST)

endef

define get_archive
	$(eval $(get_archive_impl))
endef

define get_archive_dl
	$(eval $(get_archive_dl_impl))
endef

define get_image_xz_impl
$(eval SRCDEST:=$(SOURCE)/$(L)/$(strip $(1))/$(notdir $(strip $(2))))
$(SRCDEST):
	@echo "Fetching $$@"
	mkdir -p $(SOURCE)/$(L)/$(strip $(1))
	wget $(WGET_FLAGS) -O $$@ $(2)
	unxz -k $$@


source-checkout += $(SRCDEST)

$$($(L)): $(SRCDEST)

endef

define get_image_xz
	$(eval $(get_image_xz_impl))
endef

define get_file_impl
$(eval SRCDEST:=$(SOURCE)/$(L)/$(strip $(1))/$(notdir $(strip $(2))))
$(SRCDEST):
	@echo "Fetching $$@"
	mkdir -p $(SOURCE)/$(L)/$(strip $(1))
	wget $(WGET_FLAGS) -O $$@ $(2)


source-checkout += $(SRCDEST)

$$($(L)): $(SRCDEST)

endef

define get_file
	$(eval $(get_file_impl))
endef

define print_dep_er
	echo $(1)
endef

.PHONY: dependency_error
dependency_error:
	@echo "Layer dependency not found for layer -- layer:requires "
	@$(foreach err, $(error_info), $(call print_dep_er,$(err);))
	@false

rundep_error:
	@echo "Layer runtime order not found for layer: $(error_info)" || false


define meson_build


endef

endif

