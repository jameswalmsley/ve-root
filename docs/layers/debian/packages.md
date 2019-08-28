# L_debian-packages - debian/packages

Installs packages into a debian rootfs system.

```
layers/debian/packages/layer.mk
```

# Depends

| Dependency       | Description                                  |
| ---------------- | -------------------------------------------- |
| debian-provision | Requires a base debian system to operate on. |

# Inputs

## Files

| Location                      | Override | Description                              |
| ----------------------------- | -------- | ---------------------------------------- |
| `$(RECIPE)/packages.list`     | -        | List of packages to install.             |
| `$(TOP)/packages.list`        | -        | Extends list of packages to install.     |
| `$(RECIPE)/dev-packages.list` | -        | List of development packages to install. |
| `$(TOP)/dev-packages.list`    | -        | Extends list of dev-packages to install. |

# Outputs

| Target    | Location      | Description                  |
| --------- | ------------- | ---------------------------- |
| $(ROOTFS) | $(OUT)/rootfs | Installs packages to rootfs. |
