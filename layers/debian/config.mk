DEBIAN_PATCH:=$(BASE)/layers/debian/.scripts/rootfspatch
DEBIAN_PATCH_FILE?=config.json
DEBIAN_PATCH_CONFIG:=$(call select_file,$(TOP)/$(DEBIAN_PATCH_FILE),$(RECIPE)/$(DEBIAN_PATCH_FILE))

DEBIAN_PACKAGES += apt-utils
DEBIAN_PACKAGES += kmod
DEBIAN_PACKAGES += pkg-config

