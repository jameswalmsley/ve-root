LAYER:=binutils
include $(DEFINE_LAYER)

#DEPENDS += toolchain-libs

$(call git_clone, binutils, https://github.com/bminor/binutils-gdb.git, binutils-2_29_1.1)


include $(BUILD_LAYER)
