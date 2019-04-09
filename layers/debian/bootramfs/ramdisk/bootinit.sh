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

if [ ! -e "{{ config['mount-points']['/'].blkdev }}" ]; then
    sleep 1
fi

mount -t ext4 -o ro {{ config['mount-points']['/'].blkdev }} /mnt/lower

if [ -e "/mnt/lower/.first-flash" ]; then

    mount -o remount,rw /mnt/lower
    rm /mnt/lower/.first-flash
    sync
    umount /mnt/lower

{% for k,blkdev in config['block-devices'].items() %}
    echo "INFO: Preparing Blockdevice: {{k}}"

{% if 'sffile' in blkdev %}
    sfdisk {{k}} < /partitions/{{ os.path.basename(blkdev.sffile) }}
{% endif %}

{% if 'expand' in blkdev %}
    echo "INFO: Expanding partition: {{ blkdev.expand }}"
    sfdisk -d {{k}} > ._partitions.sfdisk
    linenum=$(cat ._partitions.sfdisk | grep -n {{blkdev.expand}} | cut -d: -f1)
    sed -i "${linenum}s/size=[ \t]*[0-9]*,//" ._partitions.sfdisk
    sed -i '/^first-lba:/ d' ._partitions.sfdisk
    sed -i '/^last-lba:/ d' ._partitions.sfdisk
    sfdisk {{k}} < ._partitions.sfdisk
{% endif %}

{% endfor %}


    echo "INFO: Assuming first boot expanding rootfs..."
    e2fsck -y -f {{ config['mount-points']['/'].blkdev }}
    resize2fs {{ config['mount-points']['/'].blkdev }}
    e2fsck -y -f {{ config['mount-points']['/'].blkdev }}

{% for k,mount in config['mount-points'].items() %}
{% if 'format' in mount and 'first-flash' in mount.format %}
    echo "INFO: Formatting {{k}} partition"
    yes | mkfs.ext4 {{ mount.blkdev }}
{% endif %}
{% endfor %}
else
    umount /mnt/lower
fi


mount -t ext4 {{ config['mount-points']['/data'].blkdev }} /data
if [ $? -ne -0 ]; then
    echo "WARNING: Could not mount data partition..."
    echo "INFO: Formatting /data"
    yes | mkfs.ext4 {{ config['mount-points']['/data'].blkdev }}
    mount -t ext4 {{ config['mount-points']['/data'].blkdev }} /data

{% if 'chown' in config['mount-points']['/data'] %}
    chown -R {{config['mount-points']['/data'].chown}} /data
{% endif %}
fi


if [ -e "/data/.rw-mount" ]; then
    echo "INFO: Mounting rw-rootfs."
    mount -t ext4 -o rw {{ config['mount-points']['/'].blkdev }} /mnt/newroot
else
    echo "INFO: Mount ro-rootfs overlay."
    mount -t ext4 -o ro {{ config['mount-points']['/'].blkdev }} /mnt/lower
    mount -t overlay -o lowerdir=/mnt/lower,upperdir=/mnt/rw/upper,workdir=/mnt/rw/work overlayfs-root /mnt/newroot
fi

umount /data
rm -rf /data

{% for k,mount in config['mount-points'].items()  %}
{% if k != '/' %}

echo "INFO: Attempting to mount {{k}}"
mkdir /mnt/newroot{{k}}
mount -t ext4 {{ '-o {}'.format(mount.mount_options) if 'mount_options' in mount }} {{ mount.blkdev }} /mnt/newroot{{k}}
{% if 'chown' in mount %}
chown -R {{ mount.chown }} /mnt/newroot{{k}}
{% endif %}

{% endif %}
{% endfor %}

cd /mnt/newroot

echo "INFO: Switching into new root."
exec switch_root . lib/systemd/systemd
