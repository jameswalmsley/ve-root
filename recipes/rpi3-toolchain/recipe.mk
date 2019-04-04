include $(DEFINE_RECIPE)

TC_BUILD?=$(shell gcc -dumpmachine)
TC_HOST?=$(shell $(TC_BUILD)-gcc -dumpmachine)
TC_TARGET?=aarch64-linux-gnu
TC_PREFIX?=$(OUT)/toolchains/$(TC_HOST)/$(TC_TARGET)
TC_SYSROOT?=$(TC_PREFIX)/$(TC_TARGET)
TC_ARCH?=arm64
TC_STAMP=$(LSTAMP)/$(TC_HOST)

# HOSTENV provides CC= etc required for zlib..
TC_HOSTENV:=CC=$(TC_HOST)-gcc CXX=$(TC_HOST) AR=ar RANLIB=$(TC_HOST)-ranlib STRIP=$(TC_HOST)-strip NM=$(TC_HOST)-nm AS=$(TC_HOST)-as OBJDUMP=$(TC_HOST)-objdump

ifeq ($(TC_HOST),$(TC_BUILD))
TC_NATIVE:=y
else
TC_NATIVE:=n
endif

hostlibs:=$(BUILD)/$(TC_HOST)/host-libs

#
# Ensure compiler executables can be used during build process.
#
TC_NATIVEDIR:=$(OUT)/toolchains/$(TC_BUILD)/$(TC_TARGET)

ifeq ($(TC_NATIVE),y)
export PATH:=$(TC_PREFIX)/bin:$(PATH)
else
export PATH:=$(TC_NATIVEDIR)/bin:$(PATH)
endif

LAYERS += toolchain-libs
LAYERS += binutils


#ifeq ($(TC_NATIVE),y)
LAYERS += gcc-bootstrap
LAYERS += kernel-headers
LAYERS += glibc-bootstrap
LAYERS += libgcc
LAYERS += glibc
LAYERS += strip
#endif

LAYERS += gcc

ifneq ($(TC_NATIVE),y)
LAYERS += copylibs
endif

LAYERS += gdb

include $(BUILD_RECIPE)
