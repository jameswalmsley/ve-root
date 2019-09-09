set -ex

OUT=$1
LOOP_DEV=$(losetup -f)

PART1_OFFSET=$((2048*512))
PART1_SIZE=$((262144*512))
PART2_OFFSET=$((296978*512))
PART2_SIZE=$((262144*512))
PART3_OFFSET=$((591871*512))
PART3_SIZE=$((8388608*512))
PART4_OFFSET=$((9013247*512))
PART4_SIZE=$((262144*512))

ROOTFS_IMAGE=${OUT}/build/L_rootfs-ext4-image/rootfs.ext4.img

# RPI Bootloader
losetup -o ${PART1_OFFSET} --sizelimit ${PART1_SIZE} --sector-size 512 ${LOOP_DEV} ${OUT}/sdcard.img
mkfs.vfat ${LOOP_DEV}
mkdir -p /tmp/mntfs_boot
mount ${LOOP_DEV} /tmp/mntfs_boot
rsync -av ${OUT}/boot/* /tmp/mntfs_boot/
sync
umount /tmp/mntfs_boot
losetup -d ${LOOP_DEV}

# CONFIG RO
losetup -o ${PART2_OFFSET} --sizelimit ${PART2_SIZE} --sector-size 512 ${LOOP_DEV} ${OUT}/sdcard.img
mkfs.ext4 ${LOOP_DEV}
#mkdir -p /tmp/mntfs_configfs
#mount ${LOOP_DEV} /tmp/mntfs_configfs
#rsync -av ${OUT}/configfs/ /tmp/mntfs_configfs
#sync
#umount /tmp/mntfs_configfs
losetup -d ${LOOP_DEV}

# ROOTFS 
losetup -o ${PART3_OFFSET} --sizelimit ${PART3_SIZE} --sector-size 512 ${LOOP_DEV} ${OUT}/sdcard.img
dd if=${ROOTFS_IMAGE} of=${LOOP_DEV} status=progress
mkdir -p /tmp/mntfs_rootfs
mount ${LOOP_DEV} /tmp/mntfs_rootfs
touch /tmp/mntfs_rootfs/.first-flash
sync
umount /tmp/mntfs_rootfs
losetup -d ${LOOP_DEV}

truncate -s $((${PART3_OFFSET} + $(stat -c "%s" ${ROOTFS_IMAGE}))) ${OUT}/sdcard.img
