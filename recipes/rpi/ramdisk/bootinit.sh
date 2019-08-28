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

if [ -e "/mnt/lower/.first-flash" ]; then
    mount -o remount,rw /mnt/lower
    rm /mnt/lower/.first-flash
    sync
    umount /mnt/lower
    
    echo "INFO: Updating partition table."
    sfdisk -d /dev/mmcblk0 > partitions.sfdisk
    linenum=$(cat partitions.sfdisk | grep -n /dev/mmcblk0p4 | cut -d: -f1)

    sed -i "${linenum}s/size=[ \t]*[0-9]*,//" partitions.sfdisk

    sfdisk /dev/mmcblk0 < partitions.sfdisk

    echo "INFO: Assuming first boot expanding rootfs..."
    e2fsck -y -f /dev/mmcblk0p2
    resize2fs /dev/mmcblk0p2
    e2fsck -y -f /dev/mmcblk0p2

    yes | mkfs.ext4 /dev/mmcblk0p3
fi

umount /mnt/lower

mount -t ext4 /dev/mmcblk0p4 /data
if [ $? -ne -0 ]; then
    echo "WARNING: Could not mount data partition..."
    echo "INFO: Formatting /data"
    yes | mkfs.ext4 /dev/mmcblk0p4
    mount -t ext4 /dev/mmcblk0p4 /data

    chown -R 1000:1000 /data
fi


umount /data
rm -rf /data


if [ -e "/data/.rw-mount" ]; then
    echo "INFO: Mounting rw-rootfs."
    mount -t ext4 -o rw /dev/mmcblk0p2 /mnt/newroot
else
    echo "INFO: Mount ro-rootfs overlay."
    mount -t ext4 -o ro /dev/mmcblk0p2 /mnt/lower
    mount -t overlay -o lowerdir=/mnt/lower,upperdir=/mnt/rw/upper,workdir=/mnt/rw/work overlayfs-root /mnt/newroot
fi

echo "INFO: Attempting to mount /data"
mkdir /mnt/newroot/data
mount -t ext4 /dev/mmcblk0p4 /mnt/newroot/data

echo "INFO: Attempting to mount /config"
mkdir /mnt/newroot/config
mount -t ext4 /dev/mmcblk0p3 -o ro /mnt/newroot/config

cd /mnt/newroot

echo "INFO: Switching into new root."
exec switch_root . lib/systemd/systemd
