# L_kernel-modules - kernel/modules

Installs all kernel modules as built by L_kernel layer.

```
layers/kernel/modules/layer.mk
```

# Depends

| Dependency       | Description                                 |
| ---------------- | ------------------------------------------- |
| debian-provision | Requires a plain rootfs to install modules. |
| kernel           | Requires a configured and built kernel.     |

# Outputs

| Target            | Location  | Description          |
| ----------------- | --------- | -------------------- |
| $(kernel-modules) | $(ROOTFS) | Linux kernel modules |
