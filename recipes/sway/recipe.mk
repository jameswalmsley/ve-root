include $(DEFINE_RECIPE)

export CC=clang
export CXX=clang++

LAYERS += wayland
LAYERS += wayland-protocols
LAYERS += xwayland
LAYERS += freerdp
LAYERS += wlroots
LAYERS += sway
LAYERS += swaylock
LAYERS += waybar
LAYERS += mako
LAYERS += xdg-desktop-portal-wlr
LAYERS += wl-clipboard
LAYERS += rofi
LAYERS += swaybg
LAYERS += kitty
#LAYERS += zathura
#LAYERS += redshift
LAYERS += kanshi
LAYERS += grim
LAYERS += slurp
#LAYERS += imv
LAYERS += swaylock-effects
LAYERS += wob
LAYERS += wshowkeys
LAYERS += vte-ng
LAYERS += termite
LAYERS += light
LAYERS += pamixer


include $(BUILD_RECIPE)

