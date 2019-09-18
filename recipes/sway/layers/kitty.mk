LAYER:=kitty
include $(DEFINE_LAYER)

kitty:=$(LSTAMP)/kitty

$(L) += $(kitty)

include $(BUILD_LAYER)

$(kitty):
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
	$(stamp)

