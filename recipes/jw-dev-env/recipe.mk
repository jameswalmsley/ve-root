include $(DEFINE_RECIPE)

LAYERS += build-deps
LAYERS += fish
LAYERS += nvim

include $(BUILD_RECIPE)

