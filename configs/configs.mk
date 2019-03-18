
CONFIGS:=$(notdir $(shell ls $(BASE)/configs/*_defconfig))

.PHONY: configs
configs:
	@$(foreach config,$(CONFIGS), echo $(config);)

%_defconfig:
	cp $(BASE)/configs/$@ $(BASE)/.config

