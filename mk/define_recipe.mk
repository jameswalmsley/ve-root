MAKEFILE_LIST:=$(filter-out $(lastword $(MAKEFILE_LIST)), $(MAKEFILE_LIST))
RECIPE:=$(realpath -f $(dir $(lastword $(MAKEFILE_LIST))))

-include $(RECIPE)/config.mk

LAYERS:=
