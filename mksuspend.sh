#! /bin/bash
set -eu

BUILD_DIR="./suspend"
SUSPEND_DIR="/boot/"
CHROOTTARGET=$(readlink -f $SUSPEND_DIR$BUILD_DIR)

if [[ $# -ne 1 ]]; then
   echo "Usage: $0 <crypt_device>"
   echo "- <crypt_device> should be the root LUKS-encrypted device"
   exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo "This utility must be run as root"
   exit 2
fi

# Clear the build and destination interface
rm -Rf $BUILD_DIR
rm -Rf $CHROOTTARGET

# Populate the source folder
mkdir -p $BUILD_DIR/{dev,proc,sys,bin,var,usr,run,lib,lib64}
cp /bin/bash $BUILD_DIR/bin/
cp /bin/sync $BUILD_DIR/bin/
cp /bin/sleep $BUILD_DIR/bin/
cp /sbin/cryptsetup $BUILD_DIR/bin/
cp /usr/bin/physlock $BUILD_DIR/bin/
cp /usr/bin/pkill $BUILD_DIR/bin/
./functions/cplib.sh /bin/bash $BUILD_DIR
./functions/cplib.sh /bin/sync $BUILD_DIR
./functions/cplib.sh /bin/sleep $BUILD_DIR
./functions/cplib.sh /sbin/cryptsetup $BUILD_DIR
./functions/cplib.sh /usr/bin/physlock $BUILD_DIR
./functions/cplib.sh /usr/bin/pkill $BUILD_DIR

# Copy/Edit the Functions
cat ./functions/luksSuspend.sh | sed "s|LUKSDEVICE|$1|g" > $BUILD_DIR/luksSuspend.sh
cat ./functions/suspend.sh | sed "s|CHROOTTARGET|$CHROOTTARGET|g" > $BUILD_DIR/suspend.sh
cat ./lm/lid_change.sh | sed "s|CHROOTTARGET|$CHROOTTARGET|g" > /etc/acpi/lid_change.sh
cat ./lm/lm_lid > /etc/acpi/events/lm_lid

# Move the BUILD_DIR to the SUSPEND_DIR
mv $BUILD_DIR $SUSPEND_DIR
chmod +x $CHROOTTARGET/*.sh
chmod +x /etc/acpi/lid_change.sh

# Alter default behaviors to avoid redundant suspend (my regex-foo is weak)
sed -i 's/^#HandleLidSwitch=.*$/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sed -i 's/^HandleLidSwitch=.*$/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
echo "Default lid behavior supressed"

# Reload ACPId to pick up the changes
service acpid restart
echo "ACPId restarted"
