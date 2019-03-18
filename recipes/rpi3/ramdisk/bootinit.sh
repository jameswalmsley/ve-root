#!/bin/sh

mkdir /proc
mkdir /sys
mkdir /mnt
mkdir /data

mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
mount -t tmpfs inittemp /mnt

echo "INFO: Mounting Read-only overlay-fs."

mkdir /mnt/lower
mkdir /mnt/rw

#
# Create tmpfs for /mnt/rw for overlay rootfs.
#

mount -t tmpfs root-rw /mnt/rw

mkdir /mnt/rw/upper
mkdir /mnt/rw/work
mkdir /mnt/newroot


if [ ! -e "/dev/mmcblk0p2" ]; then
    sleep 1
fi

mount -t ext4 -o ro /dev/mmcblk0p2 /mnt/lower
mount -t overlay -o lowerdir=/mnt/lower,upperdir=/mnt/rw/upper,workdir=/mnt/rw/work overlayfs-root /mnt/newroot


#mkdir /mnt/newroot/config
#mkdir /mnt/newroot/data

echo "INFO: Attempting to mount /data"
#mount -t ext4 /dev/mmcblk2p1 /mnt/newroot/data
#mount -t ext4 /dev/mmcblk0p30 -o ro /mnt/newroot/config

cd /mnt/newroot

echo "INFO: Switching into new root."
exec switch_root . lib/systemd/systemd

