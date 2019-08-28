# L_rootfs

A sync layer that does nothing.
The purpose of this layer is to collate all components that build up
the rootfs into a single dependency.

This makes it convenient for e.g. a system image to depend on `rootfs`
and therefore guarantee that the system image will include all components
created.

This technique also decouples layers from knowledge of their base system.

A typical implementation looks like:

```
#
# META/SYNC layer for entire rootfs
#

LAYER:=rootfs
include $(DEFINE_LAYER)

rootfs:=$(LSTAMP)/rootfs

$(L) += $(rootfs)

ROOTFS_DEPENDS_LIST:=$(LAYERS_INCLUDED)

DEPENDS += $(ROOTFS_DEPENDS_LIST)

include $(BUILD_LAYER)

$(rootfs):
	$(stamp)

```

Note. All layers that create the dependency MUST be already in the LAYERS list 
before the rootfs layer is included.


# Notes

The rootfs layer also provides convenience during development:

```

make L_rootfs -j8

# Manually copy files or modify the rootfs folder using e.g. make chroot.

make -j8
```

You can also force a rebuild of non-rootfs layers e.g. system images etc.

```
make L_rootfs.i
make -j8
```

