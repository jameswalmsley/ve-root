# L_debian-depmod - debian/configure

Generates modules.dep and map files for the linux kernel module loader.

```
layers/debian/depmod.mk
```

# Depends

| Dependency     | Description                                  |
| -------------- | -------------------------------------------- |
| kernel-modules | Operates on set of installed kernel modules. |

# Inputs

## Variables

| Name         | Description                                                        |
| ------------ | ------------------------------------------------------------------ |
| KMOD_VERSION | The kernel module version tag (not always same as KERNEL_VERSION). |

# Outputs

| Target           | Location              | Description                |
| ---------------- | --------------------- | -------------------------- |
| $(debian-depmod) | $(ROOTFS)/lib/modules | modules.dep and map files. |

# Notes

KMOD_VERSION is automatically generated based on the installed / configured KERNEL_VERSION.

Other layers can use the path `$(ROOTFS)/lib/modules/$(KMOD_VERSION)` to access the correct
set of kernel modules for this build.
