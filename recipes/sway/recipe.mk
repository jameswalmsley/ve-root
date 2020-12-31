include $(DEFINE_RECIPE)

#export CC=clang
#export CXX=clang++

DEB_PACKAGES += python-packaging

LAYERS += build-deps
LAYERS += scdoc
LAYERS += wayland
LAYERS += wayland-protocols
LAYERS += xwayland
LAYERS += wlroots
LAYERS += sway
LAYERS += greetd
LAYERS += gtkgreet
LAYERS += swaylock
LAYERS += swayidle
LAYERS += swaybg
LAYERS += waybar
LAYERS += mako
LAYERS += xdg-desktop-portal-wlr
LAYERS += wl-clipboard
LAYERS += rofi

LAYERS += zathura
LAYERS += redshift
LAYERS += kanshi
LAYERS += grim
LAYERS += slurp
LAYERS += imv
LAYERS += swaylock-effects
LAYERS += wob
LAYERS += wshowkeys
LAYERS += vte-ng
LAYERS += termite
#LAYERS += light
#LAYERS += pamixer
LAYERS += wf-recorder
LAYERS += avizo

include $(BUILD_RECIPE)

