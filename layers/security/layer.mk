#
#	This layer provides some common variables for any
# 	security based feature.
#

LAYER:=security

#
# No DEFINE_LAYER/BUILD_LAYER as no targets defined.
#

KEY_PATH?=$(TOP)/test_keys
KEY_PATH_ABS:=$(shell realpath $(KEY_PATH))
