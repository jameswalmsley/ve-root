include $(BASE)/layers/debian/config.mk

#
# Base of Debian ROOTFS.
#

LAYERS += debian/debootstrap
LAYERS += debian/provision
LAYERS += debian/packages
LAYERS += debian/full-upgrade
LAYERS += debian/os-patch
LAYERS += debian/customise
LAYERS += debian/configure
LAYERS += debian/fixup-libs
