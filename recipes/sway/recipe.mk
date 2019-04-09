include $(DEFINE_RECIPE)

LAYERS += wayland
LAYERS += wayland-protocols
LAYERS += wlroots
LAYERS += sway
LAYERS += swaylock
LAYERS += waybar
LAYERS += mako

include $(BUILD_RECIPE)

