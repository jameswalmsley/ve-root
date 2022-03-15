LAYER:=sway-scripts
include $(DEFINE_LAYER)

sway-install-tools:=$(SYSROOT)/usr/local/bin/sway-install-tools
sway-enable-screenshare:=$(SYSROOT)/usr/local/bin/sway-enable-screenshare

$(L) += $(sway-install-tools)
$(L) += $(sway-enable-screenshare)

include $(BUILD_LAYER)

$(sway-enable-screenshare):
	$(SUDO) mkdir -p $(dir $@)
	$(SUDO) cp $(BASE_sway-scripts)/sway-enable-screenshare $(SYSROOT)/usr/local/bin

$(sway-install-tools):
	$(SUDO) mkdir -p $(dir $@)
	$(SUDO) echo "#!/bin/bash" | $(SUDO) tee $@
	$(SUDO) echo "apt-get -y install $(shell make deb-run-info)" | $(SUDO) tee -a $@
	$(SUDO) chmod +x $@

