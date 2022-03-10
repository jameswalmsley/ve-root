include $(DEFINE_RECIPE)

#export CC=clang
#export CXX=clang++

DEB_PACKAGES += python-packaging

LAYERS += build-deps
#LAYERS += scdoc
# LAYERS += wayland
# LAYERS += wayland-protocols
# LAYERS += inputproto
#LAYERS += libglvnd
#LAYERS += xwayland
#LAYERS += libdrm
#LAYERS += wlroots
#LAYERS += sway
# LAYERS += greetd
# LAYERS += gtkgreet
#LAYERS += sway-systemd
#LAYERS += remote-clip
LAYERS += swaylock
LAYERS += swayidle
LAYERS += swaybg
# LAYERS += waybar
LAYERS += mako
LAYERS += pipewire
LAYERS += xdg-desktop-portal-wlr
LAYERS += wl-clipboard

LAYERS += zathura
LAYERS += redshift
LAYERS += kanshi
LAYERS += grim
LAYERS += slurp
LAYERS += imv
LAYERS += swaylock-effects
LAYERS += wshowkeys
LAYERS += light
LAYERS += cxxopts
LAYERS += pamixer
LAYERS += wf-recorder
LAYERS += avizo

include $(BUILD_RECIPE)
