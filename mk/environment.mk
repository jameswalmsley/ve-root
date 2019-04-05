-include $(BASE)/.config
all:

include $(BASE)/configs/configs.mk


ifndef CONFIG_RECIPE
all: configs
info:
	@echo "You MUST configure the build system."

else

#
# Variables
#

R?=$(CONFIG_RECIPE)
OUT:=$(shell pwd)/out/$(R)
TOP:=$(BASE)/recipes/$(R)
SOURCE:=$(BASE)/sources/$(R)
BUILD:=$(OUT)/build
STAMP:=$(OUT)/.stamp
ROOTFS:=$(OUT)/rootfs

DEFINE_RECIPE:=$(BASE)/mk/define_recipe.mk
BUILD_RECIPE:=$(BASE)/mk/build_recipe.mk
DEFINE_LAYER:=$(BASE)/mk/define_layer.mk
BUILD_LAYER:=$(BASE)/mk/build_layer.mk

ENABLE_DEV?=n

define \n


endef

null:=
space:= $(null) #
comma:= ,


define touch_stamp
	mkdir -p $(dir $@) && touch $@
endef

stamp=$(call touch_stamp)


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

$(eval SRCDEST:=$(SOURCE)/$(L)/$(strip $(1))/.git/index)
$(SRCDEST):
	@echo "Cloning"
ifeq ("$(wildcard $(SRCDEST))","")
	git clone -n --single-branch --depth 1 -b $(strip $(3)) $(strip $(2)) $(SOURCE)/$(L)/$(strip $(1))
	cd $(SOURCE)/$(L)/$(strip $(1)) && git checkout $(strip $(3))
	chown -R 1000:1000 $(SOURCE)/$(L)/$(strip $(1))
endif

source-checkout += $(SRCDEST)

$$($(L)): $(SRCDEST)

endef

define git_clone
	$(eval $(git_clone_impl))
endef

#
# Archive checkouts
#

define get_archive_impl
$(eval SRCDEST:=$(SOURCE)/$(L)/$(strip $(1))/$(notdir $(strip $(2))))
$(SRCDEST):
	@echo "Fetching $$@"
	mkdir -p $(SOURCE)/$(L)/$(strip $(1))
	wget -O $$@ $(2)
	tar xvf $$@ -C $(SOURCE)/$(L)/$(strip $(1)) 


source-checkout += $(SRCDEST)

$$($(L)): $(SRCDEST)

endef

define get_archive
	$(eval $(get_archive_impl))
endef

dependency_error:
	@echo "Layer dependency not found for layer: $(error_info)"

rundep_error:
	@echo "Layer runtime order not found for layer: $(error_info)"

endif
