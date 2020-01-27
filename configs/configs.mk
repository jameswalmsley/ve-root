
CONFIGS:=$(notdir $(shell ls $(BASE)/configs/*_defconfig))

.PHONY: configs
configs:
	@$(foreach config,$(CONFIGS), echo $(config);)

define defconfig_target
$(config):
	cp $(BASE)/configs/$(config) $(BASE)/.config
endef

$(foreach config,$(CONFIGS),$(eval $(defconfig_target)))

