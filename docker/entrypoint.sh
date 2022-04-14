#!/bin/bash

set -ex

OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release)

SUDO_GROUP=wheel

[[ ${OS} == *"Ubuntu"* ]] && SUDO_GROUP=sudo

groupadd -g ${CURRENT_GID} usergroup
useradd -M -u ${CURRENT_UID} -g ${CURRENT_GID} ${CURRENT_USER}

usermod -a -G ${SUDO_GROUP} ${CURRENT_USER}

echo "root   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
echo "${CURRENT_USER}   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

exec sudo -i -u ${CURRENT_USER} /userentry.sh ${CURRENT_DIR} $@

