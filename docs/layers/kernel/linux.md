# L_kernel - kernel/linux

Builds a linux kernel specifically for the configured recipe.

```
layers/kernel/linux/layer.mk
```

# Inputs

## Files

| Location                          | Override        | Description          |
| --------------------------------- | --------------- | -------------------- |
| `$(RECIPE)/kconfigs/linux.config` | $(LINUX_CONFIG) | Kernel Kconfig file. |

## Variables

| Name            | Description                                                  |
| --------------- | ------------------------------------------------------------ |
| LINUX_GIT_URL   | GIT Repo to clone kernel sources.                            |
| LINUX_GIT_REF   | GIT reference (sha/tag/branch...) to checkout.               |
| LINUX_CONFIG    | Updates location of the kernel Kconfig file.                 |
| LINUX_DEFCONFIG | Name of defconfig to use when $(LINUX_CONFIG) doesn't exist. |
| KERNEL_OUT      | $(BUILD)/$(L)/linux                                          |

# Outputs

| Target           | Location                              | Description                      |
| ---------------- | ------------------------------------- | -------------------------------- |
| $(kernel)        | $(KERNEL_OUT)/arch/$(ARCH)/boot/Image | Linux kernel Image               |
| $(kernel-config) | $(KERNEL_OUT)/.config                 | Linux kernel configuration file. |

# Command Targets

| Command       | Description                                  |
| ------------- | -------------------------------------------- |
| kernel-config | Runs menuconfig on $(LINUX_CONFIG) file.     |
| kernelversion | Prints the kernelversion from linux sources. |
| dtbs          | Builds the kernels dtbs files.               |
