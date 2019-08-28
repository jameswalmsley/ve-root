# L_debian-full-upgrade - debian/full-upgrade

Performs a full-upgrade (apt) on a debian based system.

```
layers/debian/full-upgrade/layer.mk
```

# Depends

| Dependency       | Description                                  |
| ---------------- | -------------------------------------------- |
| debian-provision | Requires a base debian system to operate on. |

# Inputs

## Variables

| Name       | Description                                             |
| ---------- | ------------------------------------------------------- |
| QEMU_START | Command to enable qemu emulation in the docker chroot.  |
| QEMU_DONE  | Command to cleanup qemu emulation in the docker chroot. |

# Outputs

| Target    | Location      | Description                             |
| --------- | ------------- | --------------------------------------- |
| $(ROOTFS) | $(OUT)/rootfs | Updated packages installed into rootfs. |

# Notes

It is recommended that released embedded devices don't automatically update
in the field. (Unless you have setup your own debian apt repo, and are
able to manage that internally).

```
# Debian updates can override the custom OS patches.. breaking the base system.
# It is important that L_debian-os-patch etc run after a full-upgrade.
```

To periodically release a "updated" rootfs perform the following commands.

```
make L_debian-full-upgrade.i
make L_debian-full-upgrade
make -j8

# Distribute fw-update packages.
```
