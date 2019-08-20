LAYER:=debian-customise
include $(DEFINE_LAYER)

debian-customise-suffix:=

ifeq ($(CONFIG_RELEASE),y)
debian-customise-suffix:=$(strip $(debian-customise-suffix)).release
endif

debian-customise:=$(LSTAMP)/customise$(debian-customise-suffix)

$(L) += $(debian-customise)

DEPENDS += debian-provision
DEPENDS += debian-os-patch

include $(BUILD_LAYER)


$(debian-customise):
ifneq ($(wildcard $(RECIPE)/rootfs),)
	rsync -av --checksum --chown=root:root --chmod=D755,F644 $(RECIPE)/rootfs/ $(ROOTFS)/
endif
ifneq ($(RECIPE),$(TOP))
ifneq ($(wildcard $(TOP)/rootfs),)
	rsync -av --checksum --chown=root:root --chmod=D755,F644 $(TOP)/rootfs/ $(ROOTFS)/
endif
endif
ifneq ($(CONFIG_RELEASE),y)
ifneq ($(wildcard $(RECIPE)/dev-rootfs),)
	rsync -av --checksum --chown=root:root --chmod-D755,F644 $(RECIPE)/dev-rootfs/ $(ROOTFS)/
endif
ifneq ($(RECIPE),$(TOP))
ifneq ($(wildcard $(TOP)/dev-rootfs),)
	rsync -av --checksum --chown=root:root --chmod=D755,F644 $(TOP)/dev-rootfs/ $(ROOTFS)/
endif
endif
endif
	$(stamp)

ifneq ($(wildcard $(RECIPE)/rootfs),)
$(debian-customise): $(shell find $(RECIPE)/rootfs -type f)
endif

ifneq ($(wildcard $(RECIPE)/dev-rootfs),)
$(debian-customise): $(shell find $(RECIPE)/dev-rootfs -type f)
endif

ifneq ($(RECIPE),$(TOP))
ifneq ($(wildcard $(TOP)/rootfs),)
$(debian-customise): $(shell find $(TOP)/rootfs -type f)
endif
ifneq ($(wildcard $(TOP)/dev-rootfs),)
$(debian-customise): $(shell find $(TOP)/dev-rootfs -type f)
endif
endif
