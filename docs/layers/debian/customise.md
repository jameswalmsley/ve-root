# L_debian-customise - debian/customise

Copies the rootfs folder from the $(RECIPE) and $(TOP) directories.

```
debian/customise.mk
```

# Depends

| Dependency       | Description                       |
| ---------------- | --------------------------------- |
| debian-provision | Operates on a base debian system. |
| debian-os-patch  |                                   |

# Inputs

## Files

| Location                | Override | Description                                                    |
| ----------------------- | -------- | -------------------------------------------------------------- |
| `$(RECIPE)/rootfs/`     | -        | Copies rootfs files from base recipe.                          |
| `$(TOP)/rootfs/`        | -        | Copies rootfs files from top recipe if applicable.             |
| `$(RECIPE)/dev-rootfs/` | -        | Copies dev rootfs files from recipe. (CONFIG_RELEASE != y)     |
| `$(TOP)/dev-rootfs/`    | -        | Copies dev rootfs files from top recipe. (CONFIG_RELEASE != y) |

## Variables

| Name           | Description                                           |
| -------------- | ----------------------------------------------------- |
| CONFIG_RELEASE | When enabled the dev-rootfs files will not be copied. |

# Outputs

| Target           | Location                              | Description                      |
| ---------------- | ------------------------------------- | -------------------------------- |
| $(kernel)        | $(KERNEL_OUT)/arch/$(ARCH)/boot/Image | Linux kernel Image               |

# Command Targets

| Command       | Description                                  |
| ------------- | -------------------------------------------- |
| kernel-config | Runs menuconfig on $(LINUX_CONFIG) file.     |

# Notes

When CONFIG_RELEASE:=y the dev-rootfs files will not be applied.
This allows convenient development only features to be easily applied.
