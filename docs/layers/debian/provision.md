# L_debian-provision - debian/provision

Provides a provisioning layer for L_debian-debootstrap.

```
layers/debian/provision/layer.mk
```

# Depends

* debian-debootstrap


# Outputs

| Target    | Location      | Description           |
| --------- | ------------- | --------------------- |
| $(ROOTFS) | $(OUT)/rootfs | Initial rootfs files. |
