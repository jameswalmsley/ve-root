# L_debian-configure - debian/configure

Configures the debian system based on the top-level config file ($(TOP)/config.json).

Further it executes a configure.sh shell script from the base $(RECIPE), and if
applicable executes a configure.sh shell script from the top $(TOP) recipe.

```
layers/debian/configure/layer.mk
```

# Depends

| Dependency       | Description                                           |
| ---------------- | ----------------------------------------------------- |
| debian-provision | Requires a base system.                               |
| debian-packages  | Ensure all packages are installed before configuring. |

# Inputs

## Files

| Location                         | Override          | Description                                    |
| -------------------------------- | ----------------- | ---------------------------------------------- |
| `$(TOP)/config.json`             | DEBIAN_PATCH_FILE | Config json file used to confgure base system. |
| `$(RECIPE)/scripts/configure.sh` | -                 | Configure script for the base recipe.          |
| `$(TOP)/scripts/configure.sh`    | -                 | Configure script for the top recipe.           |


# Outputs

| Target    | Location  | Description                          |
| --------- | --------- | ------------------------------------ |
| $(ROOTFS) | $(ROOTFS) | Applies configuration to the rootfs. |

# Notes

Configure order is $(RECIPE) followed by $(TOP) so that the $(TOP) recipe can modify
or alter any configuration performed by the base recipe.
