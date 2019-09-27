include $(DEFINE_RECIPE)

LAYERS += wayland
LAYERS += wayland-protocols
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
LAYERS += redshift
LAYERS += kanshi
LAYERS += grim
LAYERS += slurp
#LAYERS += imv
LAYERS += swaylock-effects
LAYERS += wob

include $(BUILD_RECIPE)

