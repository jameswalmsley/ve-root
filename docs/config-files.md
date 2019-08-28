# Config File

VE-ROOT includes a template system that is used to customise the OS and init scripts.

# `distro`

Defines the top-level 'distro' properties.

| Key     | Description                                                    |
| ------- | -------------------------------------------------------------- |
| name    | Top-level OS system name, e.g. Ubuntu or your own custom name. |
| version | Major version number of your distro.                           |
| support | Support URL for the system being built.                        |

# `system`

Configures the operating system with e.g. hostnames, users and network config.

| Key      | Description                  |
| -------- | ---------------------------- |
| hostname | Network hostname of device.  |
| users    | Dictionary of user accounts. |
| network  | Network config options       |
|          |                              |


# `aptitude`

| Key     | Description                            |
| ------- | -------------------------------------- |
| sources | List of aptitude sources.list entries. |
|         |                                        |

# `block-devices`

A dictionary of block devices used by the system.

# `mount-points`

A dictionary of mount-points.

# `bootimage`

Configures the bootloader (U-Boot) bootimage.

| Key          | Description                            |
| ------------ | -------------------------------------- |
| kernel_load  | Hex address to load the kernel image.  |
| kernel_entry | Hex address of the kernel entry point. |
| dtb_load     | Hex address to load board dtb file.    |
| initrd_load  | Hex address to load the initramfs.     |
| kernel_image | Name of the kernel Image file.         |
| initramfs    | Name of bootramfs.cpio.gz fille.       |
| boot-config  | Location of boot-config files (/data)  |
