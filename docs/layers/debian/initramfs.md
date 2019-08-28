# L_debian-initramfs - debian/initramfs

Generates a basic debian initramfs and caches the result under
INITRAMFS_OUT for use by other initramfs layers.

```
layers/debian/initramfs.mk
```

# Depends

| Dependency       | Description                    |
| ---------------- | ------------------------------ |
| debian-provision | Requires a base debian system. |


# Notes

Adds initramfs-tools to the DEBIAN_PACKAGES list.

