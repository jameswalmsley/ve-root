#
# Provides integration for:
#
# systemd  - Start login manager as a service for graphical.target.
# pam      - Security configuration for gnome-keyring.
# greetd   - Login / greeting manager.
# gtkgreet - Wayland supporting login screen, with xdg-layer-shell support.
# dbus     - Ensure system starts under a valid dbus session.
# keyring  - Correct login authentication for gnome-keyring.
#
LAYER:=sway-systemd
include $(DEFINE_LAYER)

DEPENDS += sway
DEPENDS += greetd
DEPENDS += gtkgreet

greetd.service:=/etc/systemd/system/greetd.service
gnome-keyring.pam:=$(LSTAMP)/gnome-keyring.pam
greetd.pam:=/etc/pam.d/greetd
greetd.config:=/etc/greetd/config.toml
greetd.environments:=/etc/greetd/environments
greetd.sway-config:=/etc/greetd/sway-config
sway-run:=/usr/local/bin/sway-run
sway-wayland-enablement:=/usr/local/bin/wayland_enablement.sh

$(L) += $(greetd.service)
#$(L) += $(gnome-keyring.pam)
#$(L) += $(greetd.pam)
$(L) += $(greetd.config)
$(L) += $(greetd.environments)
$(L) += $(greetd.sway-config)
$(L) += $(sway-wayland-enablement)
$(L) += $(sway-run)

include $(BUILD_LAYER)

$(greetd.service):
	sudo cp $(SRC_greetd)/greetd/greetd.service $@

$(greetd.pam):
	@echo sudo cp $(BASE_sway-systemd)/etc/pam.d/greetd  /etc/pam.d/greetd

$(greetd.environments):
	sudo cp $(BASE_sway-systemd)/etc/greetd/environments $@

$(greetd.config):
	sudo cp $(BASE_sway-systemd)/etc/greetd/config.toml $@

$(greetd.sway-config):
	sudo cp $(BASE_sway-systemd)/etc/greetd/sway-config $@

$(sway-wayland-enablement):
	sudo cp $(BASE_sway-systemd)/usr/local/bin/wayland_enablement.sh $@

$(sway-run):
	sudo cp $(BASE_sway-systemd)/usr/local/bin/sway-run $@
