#!/bin/bash

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

#
#   Ensure the init script points to systemd.
#
if [ ! -e "/sbin/init" ]; then
ln -s /lib/systemd/systemd /sbin/init
fi

 
