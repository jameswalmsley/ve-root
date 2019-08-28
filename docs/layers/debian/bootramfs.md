# L_debian-bootramfs - debian/bootramfs

Generates a bootable initramfs with init script correctly configured
to boot the system.

Generates init scripts based on the $(RECIPE/TOP)/config.json files.

```
layers/debian/bootramfs/layer.mk
```

# Depends

| Dependency       | Description                                            |
| ---------------- | ------------------------------------------------------ |
| debian-initramfs | Requires the cached initramfs base under INITRAMFS_OUT |

# Inputs

## Files

| Location                            | Override | Description                 |
| ----------------------------------- | -------- | --------------------------- |
| `$(DEBIAN_PATCH_CONFIG)`            | -        | $(RECIPE/TOP)/config.json   |
| `confg.json:block-devices/*/sffile` | -        | Partition description file. |

## Variables

| Name      | Description                                                   |
| --------- | ------------------------------------------------------------- |
| BOOTFILES | List of files to copy into bootramfs, `source/path:dest/path` |


# Outputs

| Target                | Location                                   | Description                    |
| --------------------- | ------------------------------------------ | ------------------------------ |
| $(debian-bootramfs)   | $(BUILD)/L_bootramfs/bootramfs.cpio.gz     | Initramfs for booting system.  |
| $(debian-updateramfs) | $(BUILD)/L_bootramfs/updateramfs.cpio.gz   | Initramfs for updating system. |
| $(bootinit.sh)        | $(BUILD)/L_bootramfs/ramdisk/bootinit.sh   | Initscript for kernel boot.    |
| $(updateinit.sh)      | $(BUILD)/L_bootramfs/ramdisk/updateinit.sh | Update init script.            |


# Notes

## sfdisk Files

The config.json file defines block-devices and mount-points. Each block device may specify
an sf file (script for the sfdisk tool).

During a factory initialisation (where the file /data/.first-flash exists) an sfdisk file will be
applied to the specified partition.

## Mount Point Options

In the config.json file, each mount point may specify a "format" option with the following values:

| Option        | Description                                                       |
| ------------- | ----------------------------------------------------------------- |
| `first-flash` | Format the partition on factory initialisation (first-flash).     |
| `mount-error` | Format the partition if init script fails to mount the partition. |

