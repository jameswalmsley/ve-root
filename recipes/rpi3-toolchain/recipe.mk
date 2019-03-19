include $(DEFINE_RECIPE)

LAYERS += toolchain-libs
LAYERS += binutils

hostlibs:=$(OUT)/host-libs


TC_BUILD?=$(shell gcc -dumpmachine)
TC_HOST?=$(shell $(TC_BUILD)-gcc -dumpmachine)
TC_TARGET?=aarch64-linux-gnu
TC_PREFIX?=$(OUT)/$(TC_HOST)/$(TC_TARGET)

TC_HOSTENV:=CC=$(TC_HOST)-gcc CXX=$(TC_HOST) AR=ar RANLIB=$(TC_HOST)-ranlib STRIP=$(TC_HOST)-strip NM=$(TC_HOST)-nm AS=$(TC_HOST)-as OBJDUMP=$(TC_HOST)-objdump

include $(BUILD_RECIPE)

