# Initial configure script.

# System users
adduser {{ system.hostname }} --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password

# Only set a password if ENABLE_DEV is set.
if [ "$ENABLE_DEV" == "y" ]
then
    echo "WARNING: Developer mode enabled - setting password!"
    echo "{{ system.user }}:{{ system.pass }}" | chpasswd
fi

# Hostname
echo "{{ system.hostname }}" > /etc/hostname

# Setup sudo.
chown root:root /usr/bin/sudo
chmod u+s /usr/bin/sudo

apt autoremove
apt autoclean
apt clean
