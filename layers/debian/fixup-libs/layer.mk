#
# A few debian libs have symlinks targeting absolute paths.
# This is causes an error when cross-compiling, or could cause
# a target on the BUILD machine to be incorrectly linked against.
#
# This script requires the usrmerge package to be installed.
# It works by finding all symlinked libraries in the arch-triplet
# under /usr/lib and replacing any absolute paths with relative paths.
#

LAYER:=debian-fixup-libs
include $(DEFINE_LAYER)

debian-fixup-libs:=$(LSTAMP)/debian-fixup-libs

$(L) += $(debian-fixup-libs)

DEPENDS += debian-packages
DEPENDS += debian-full-upgrade

include $(BUILD_LAYER)

$(debian-fixup-libs):
	cd $(ROOTFS) && MULTIARCH=$(DEBIAN_ARCH_TRIPLET) bash $(BASE_debian-fixup-libs)/fixup-libs.sh
	$(stamp)
