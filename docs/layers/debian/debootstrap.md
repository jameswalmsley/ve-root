# L_debian-debootstrap - debian/debootstrap

Run's an initial debootstap for the configured recipe.
This initial bootstrap provides a small cache of the base debian system.

```
layers/debian/debootstrap/layer.mk
```

# Inputs

## Variables

| Name            | Description                              |
| --------------- | ---------------------------------------- |
| DEBIAN_PACKAGES | List of debian package names to install. |

# Outputs

| Target                             | Location | Description           |
| ---------------------------------- | -------- | --------------------- |
| $(BUILD_debian-debootstrap)/rootfs |          | Initial rootfs files. |

