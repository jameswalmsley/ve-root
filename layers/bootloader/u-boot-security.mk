LAYER:=uboot-security
LAYER_NODEPEND_FILE:=y
include $(DEFINE_LAYER)

uboot_private_key:=$(KEY_PATH_ABS)/uboot_rsa_dev.key
uboot_public_key:=$(KEY_PATH_ABS)/uboot_rsa_dev.crt

$(L) += $(uboot_private_key)
$(L) += $(uboot_public_key)

include $(BUILD_LAYER)

$(uboot_private_key):
	mkdir -p $(dir $@)
	openssl genrsa -F4 -out $@ 2048

$(uboot_public_key): $(uboot_private_key)
	openssl req -batch -new -x509 -key $(@:%.crt=%.key) -out $@
