include $(DEFINE_RECIPE)

LAYERS += build-deps
LAYERS += fish
LAYERS += nvim
LAYERS += tmux

include $(BUILD_RECIPE)

