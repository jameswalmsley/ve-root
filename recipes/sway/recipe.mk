include $(DEFINE_RECIPE)

LAYERS += wayland
LAYERS += wayland-protocols
LAYERS += wlroots
LAYERS += sway
LAYERS += swaylock
LAYERS += waybar
LAYERS += mako
LAYERS += xdg-desktop-portal-wlr


LAYERS += kitty


include $(BUILD_RECIPE)

