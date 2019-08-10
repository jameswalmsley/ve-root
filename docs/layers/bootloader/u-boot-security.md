# L_uboot-security - bootloader/u-boot-security

Generate boot signing/verification keys for u-boot.

```
layers/bootloader/u-boot-security.mk
```

```
LAYER_NODEPEND_FILE:=y

This layer will not overwrite generated keys if modified.
```

# Depends

L_security

# Outputs

| Target               | Location                      | Description                      |
| -------------------- | ----------------------------- | -------------------------------- |
| $(uboot_private_key) | $(KEY_PATH)/uboot_rsa_dev.key | u-boot rsa device key (private). |
| $(uboot_public_key)  | $(KEY_PATH)/uboot_rsa_dev.crt | u-boot rsa device key (public).  |

