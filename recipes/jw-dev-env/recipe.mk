include $(DEFINE_RECIPE)

export DESTDIR:=$(ROOTFS)

LAYERS += build-deps
LAYERS += fish
LAYERS += nvim
LAYERS += tmux

include $(BUILD_RECIPE)

