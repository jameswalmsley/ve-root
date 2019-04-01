#!/bin/sh

sleep 2
echo "Firmware update ..."

mkdir /proc
mkdir /sys
mkdir /mnt
mkdir /data

mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev
mount -t tmpfs inittemp /mnt

echo "Waiting for MMC storage to be ready..."

mount -t ext4 /dev/mmcblk0p4 /data

if [ -e "/data/boot.img" ]; then
echo "INFO: Updating boot partition..."
pv /data/boot.img | dd of=/dev/mmcblk0p1 bs=1048576
fi

if [ -e "/data/system.img" ]; then
echo "INFO: Updating encrypted system image..."

else

if [ -e "/data/system.img.gz" ]; then
echo "INFO: Updating compressed system image..."i
pv /data/system.img.gz | gunzip -c | dd of=/dev/mmcblk0p2 bs=1048576
e2fsck -y -f /dev/mmcblk0p2
resize2fs /dev/mmcblk0p2
e2fsck -y -f /dev/mmcblk0p2
fi

fi

mv /data/updateimage.fit /data/updateimage.fit.done

sync

sleep 1

echo "INFO: Update applied."

sleep 1

reboot
