include $(DEFINE_RECIPE)

#export CC=clang
#export CXX=clang++

LAYERS += build-deps
LAYERS += wayland
LAYERS += wayland-protocols
LAYERS += xwayland
#LAYERS += freerdp
LAYERS += wlroots
LAYERS += sway
LAYERS += swaylock
LAYERS += waybar
LAYERS += mako
LAYERS += xdg-desktop-portal-wlr
LAYERS += wl-clipboard
LAYERS += rofi
LAYERS += swaybg

ifeq ($(shell $(BASE)/scripts/version-parse.py --gteq $(shell pkg-config --modversion girara-gtk3) 0.3.3),y)
LAYERS += zathura
endif
#LAYERS += redshift
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
LAYERS += vim

include $(BUILD_RECIPE)

