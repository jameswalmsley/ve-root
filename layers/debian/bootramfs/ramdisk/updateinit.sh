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

mount -t ext4 {{ config['mount-points']['/data'].blkdev }} /data

if [ -e "/data/boot.img" ]; then
echo "INFO: Updating boot partition..."
pv /data/boot.img | dd of={{ config['mount-points']['/boot'].blkdev }} bs=1048576
fi

if [ -e "/data/system.img" ]; then
echo "INFO: Updating encrypted system image..."

else

if [ -e "/data/system.img.gz" ]; then
echo "INFO: Updating compressed system image..."i
pv /data/system.img.gz | gunzip -c | dd of={{config['mount-points']['/'].blkdev}} bs=1048576
e2fsck -y -f {{config['mount-points']['/'].blkdev}}
resize2fs {{config['mount-points']['/'].blkdev}}
e2fsck -y -f {{config['mount-points']['/'].blkdev}}
fi

fi

mv /data/updateimage.fit /data/updateimage.fit.done

sync

sleep 1

echo "INFO: Update applied."

sleep 1

reboot
