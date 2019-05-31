#!/bin/bash

set -e

#
#   Extra development packages.
#
chmod 1777 /tmp
mv /etc/resolv.conf /etc/resolv.conf.old
echo "nameserver 8.8.8.8" > /etc/resolv.conf

DPKG_OPTIONS="-o DPkg::Options::=--force-confdef"

apt update
DEBIAN_FRONTEND=noninteractive apt -y full-upgrade ${DPKG_OPTIONS}

rm /etc/resolv.conf
mv /etc/resolv.conf.old /etc/resolv.conf

rm -rf /tmp/*
