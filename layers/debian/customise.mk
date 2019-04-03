LAYER:=debian-customise
include $(DEFINE_LAYER)

debian-customise:=$(LSTAMP)/customise

$(L) += $(debian-customise)

DEPENDS += debian-provision

include $(BUILD_LAYER)


$(debian-customise):
	rsync -av --checksum --chown=root:root --chmod=D755,F644 $(RECIPE)/rootfs/ $(ROOTFS)/
ifeq ($(ENABLE_DEV),y)
	rsync -av --checksum --chown=root:root --chmod=D755,F644 $(RECIPE)/dev-rootfs/ $(ROOTFS)/
endif
ifneq ($(RECIPE),$(TOP))
	rsync -av --checksum --chown=root:root --chmod=D755,F644 $(TOP)/rootfs/ $(ROOTFS)/
endif
	$(stamp)


$(debian-customise): $(shell find $(RECIPE)/rootfs -type f) $(shell find $(RECIPE)/dev-rootfs -type f)

ifneq ($(RECIPE),$(TOP))
$(debian-customise): $(shell find $(TOP)/rootfs -type f)
endif
