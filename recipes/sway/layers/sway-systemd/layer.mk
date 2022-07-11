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

greetd.service:=$(SYSROOT)/etc/systemd/system/greetd.service
gnome-keyring.pam:=$(LSTAMP)/gnome-keyring.pam
greetd.pam:=$(SYSROOT)/etc/pam.d/greetd
greetd.config:=$(SYSROOT)/etc/greetd/config.toml
greetd.environments:=$(SYSROOT)/etc/greetd/environments
greetd.sway-config:=$(SYSROOT)/etc/greetd/sway-config
sway-run:=$(SYSROOT)/usr/local/bin/sway-run
sway-wayland-enablement:=$(SYSROOT)/usr/local/bin/wayland_enablement.sh
sway-session:=$(SYSROOT)/usr/local/share/wayland-sessions/sway.desktop

# $(L) += $(greetd.service)
#$(L) += $(gnome-keyring.pam)
#$(L) += $(greetd.pam)
# $(L) += $(greetd.config)
# $(L) += $(greetd.environments)
# $(L) += $(greetd.sway-config)
$(L) += $(sway-wayland-enablement)
$(L) += $(sway-run)
$(L) += $(sway-session)

include $(BUILD_LAYER)

$(greetd.service):
	$(SUDO) cp $(SRC_greetd)/greetd/greetd.service $@

$(greetd.pam):
	@echo $(SUDO) cp $(BASE_sway-systemd)/etc/pam.d/greetd  $@

$(greetd.environments):
	$(SUDO) cp $(BASE_sway-systemd)/etc/greetd/environments $@

$(greetd.config):
	$(SUDO) cp $(BASE_sway-systemd)/etc/greetd/config.toml $@

$(greetd.sway-config):
	$(SUDO) cp $(BASE_sway-systemd)/etc/greetd/sway-config $@

$(sway-wayland-enablement):
	$(SUDO) cp $(BASE_sway-systemd)/usr/local/bin/wayland_enablement.sh $@

$(sway-run):
	$(SUDO) cp $(BASE_sway-systemd)/usr/local/bin/sway-run $@

$(sway-session):
	$(SUDO) cp $(BASE_sway-systemd)/usr/local/share/wayland-sessions/sway.desktop $@
