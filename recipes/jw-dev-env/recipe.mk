include $(DEFINE_RECIPE)

export DESTDIR:=$(ROOTFS)

LAYERS += build-deps
LAYERS += fish
LAYERS += tmux
LAYERS += nvim

include $(BUILD_RECIPE)

