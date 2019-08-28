# L_rootfs-permissions - rootfs/permission

Applies permissions to any files under the $(ROOTFS) path based
on table described in $(RECIPE|TOP)/permissions.list.

```
layers/rootfs/permissions/layer.mk
```

# Depends

| Dependency       | Description                                       |
| ---------------- | ------------------------------------------------- |
| debian-customise | Requires all packages and customisations applied. |

# Inputs

## Files

| Location                     | Override | Description          |
| ---------------------------- | -------- | -------------------- |
| `$(RECIPE)/permissions.list` | -        | List of permissions. |
| `$TOP)/permissions.list`     |          | ...                  |

### permissions.list

':' separated table.

(path) : { arguments to find } : Command to execute

Lines where 1st char is # are comments.

Command can be anything installed in the rootfs.

```
# Path:find-args:Command

# Modify all dirs under /root
/root:-type d:chmod -R 700

# Modify all files under /root
/root:-type f:chmod -R 644

# Change ownership of all files in /home/rpi
# note. find command is unused.
/home/rpi/::chown -R 1000:1000

/home/rpi/:-type f:chmod 644

# Modify a single file.
/usr/bin/jetson_clocks::chmod +x
```

# Outputs

| Target                | Location  | Description                           |
| --------------------- | --------- | ------------------------------------- |
| $(rootfs-permissions) | $(ROOTFS) | Permissions applied within $(ROOTFS). |


# Notes

All permissions are applied inside a chroot jail using qemu.

The permissions script is implemented under:
`layers/rootfs/permissions/permissions.sh`
