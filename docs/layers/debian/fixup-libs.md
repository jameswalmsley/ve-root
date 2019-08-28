# L_debian-fixup-libs - debian/fixup-libs

Fixes up system libraries to ensure all symlinks use relative paths.
This is required so that an exported sysroot for cross compilation works.

```
layers/debian/fixup-libs/layer.mk
```

# Depends

| Dependency          | Description                             |
| ------------------- | --------------------------------------- |
| debian-packages     | Requires all libraries to be installed. |
| debian-full-upgrade | ... ^^^                                 |

# Outputs

| Target    | Location | Description                                 |
| --------- | -------- | ------------------------------------------- |
| $(ROOTFS) |          | Modifies all library symlinks in $(ROOTFS). |
