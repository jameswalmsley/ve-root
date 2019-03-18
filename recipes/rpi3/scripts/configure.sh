#!/bin/bash

cat /permissions.list | while read perm
do
    echo $perm

    if [[ "$perm" == "#"* ]] ; then
        echo comment
    else
        path=$(echo $perm | cut -d : -f1)
        type=$(echo $perm | cut -d : -f2)
        options=$(echo $perm | cut -d : -f3)
        mode=$(echo $perm | cut -d : -f4)

        [ -z "$options" ] && options=$options || options=-$options
        [ -z "$type" ] && type=$type || type="-type $type"

        if [[ $options =~ "R" ]] ; then
            echo "find $path $type | xargs chmod $options $mode"
            find $path $type | xargs chmod $options $mode || true
        else
            chmod $options $mode $path || true
        fi
    fi
done

adduser ilmd sudo

echo "Enable resolved"
systemctl enable systemd-resolved.service
echo "Enable networkd"
systemctl enable systemd-networkd.service

# Setup systemd-networking
rm /etc/resolv.conf
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

systemctl enable wpa_supplicant@wlan0

if [ "$ENABLE_DEV" == "y" ]
then
    echo "DEVELOPER MODE - Not disabling terminals"
    systemctl enable getty@tty1.service
    ln -s /lib/systemd/system/getty-static.service /lib/systemd/system/getty.target.wants/getty-static.service
else
    echo "Disable getty@tty1.service"
    systemctl disable getty@tty1.service
    echo "Disable additional TTYs"
    rm /lib/systemd/system/getty.target.wants/getty-static.service
    echo "Disable serial console"
    systemctl mask serial-getty@ttyS0
fi

echo "Enable watchdog service"
systemctl enable watchdog.service

#
#   Ensure the init script points to systemd.
#
if [ ! -e "/sbin/init" ]; then
ln -s /lib/systemd/systemd /sbin/init
fi

echo "depmod $1"
depmod $1
ldconfig


#
#   Extra development packages.
#
echo "deb http://ports.ubuntu.com/ubuntu-ports bionic main restricted" > /etc/apt/sources.list
echo "deb http://ports.ubuntu.com/ubuntu-ports bionic-updates main restricted" >> /etc/apt/sources.list
echo "deb http://ports.ubuntu.com/ubuntu-ports bionic universe" >> /etc/apt/sources.list
echo "deb http://ports.ubuntu.com/ubuntu-ports bionic-updates universe" >> /etc/apt/sources.list


chmod 1777 /tmp

mv /etc/resolv.conf /etc/resolv.conf.old
echo "nameserver 8.8.8.8" > /etc/resolv.conf

apt update
DEBIAN_FRONTEND=noninteractive apt -y full-upgrade -o DPkg::Options::=--force-confdef

if [ "$ENABLE_DEV" == "y" ]
then
    PACKAGES=$(cat dev-packages.list  | xargs)
    DEBIAN_FRONTEND=noninteractive apt -y install $PACKAGES
fi

rm /etc/resolv.conf
mv /etc/resolv.conf.old /etc/resolv.conf

apt -y autoclean
apt -y clean

rm -rf /tmp/*
 
