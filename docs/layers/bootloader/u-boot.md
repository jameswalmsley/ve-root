# L_bootloader - bootloader/u-boot

Build the u-boot from source.

```
layers/bootloader/u-boot.mk
```

# Depends
| Layer Dependency                     | Description                                            |
| ------------------------------------ | ------------------------------------------------------ |
| [uboot-security](u-boot-security.md) | Provides key files when CONFIG_SECURE_BOOT is enabled. |
|                                      |                                                        |

# Inputs

## Files

## Variables

| Name            | Description                          |
| --------------- | ------------------------------------ |
| UBOOT_GIT_URL   | GIT Repo to clone u-boot sources.    |
| UBOOT_GIT_REF   | GIT reference to checkout.           |
| UBOOT_CONFIG    | Location of the U-Boot Kconfig file. |
| UBOOT_DEFCONFIG |                                      |

## Configs (Supported)

| Name               |     | Description                                          |
| ------------------ | --- | ---------------------------------------------------- |
| CONFIG_SECURE_BOOT |     | Builds u-boot with support for verified/secure boot. |


# Outputs

| Target               | Location                                | Description                             |
| -------------------- | --------------------------------------- | --------------------------------------- |
| $(bootloader)        | $(UBOOT_OUT)/u-boot.bin                 | u-boot binary image.                    |
| $(bootloader-config) | $(UBOOT_OUT)/.config                    | u-boot build configuration file.        |
| $(bootloader-signed) | $(UBOOT_SIGNED_OUT)/u-boot-sign-dtb.bin | u-boot with embedded verification keys. |

# Command Targets

