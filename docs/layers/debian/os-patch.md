# L_debian-os-patch - debian/os-patch

Patches the base debian system with customisations from:

`layers/debian/os-patch/rootfs/*`

```
layers/debian/os-patch/layer.mk
```

# Depends

| Dependency          | Description                                 |
| ------------------- | ------------------------------------------- |
| debian-packages     | Requires all packages to be installed.      |
| debian-full-upgrade | Patch MUST be applied after a full-upgrade. |

# Inputs

## Files

| Location                         | Override | Description                     |
| -------------------------------- | -------- | ------------------------------- |
| `$(BASE_debian-os-patch)/rootfs` | -        | Patch files to override system. |
| `$(DEBIAN_PATCH_CONFIG)`         |          | Usually $(RECIPE)/config.json   |

# Outputs

| Target    | Location      | Description                    |
| --------- | ------------- | ------------------------------ |
| $(ROOTFS) | $(OUT)/rootfs | Patches applied over $(ROOTFS) |

# Notes

This layer is configured based on a config.json file.

