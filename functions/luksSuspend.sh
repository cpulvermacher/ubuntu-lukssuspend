#! /bin/bash

function do_suspend() {
   #/usr/sbin/pm-suspend
   echo -n "mem" > /sys/power/state
}

sync
cryptsetup luksSuspend LUKSDEVICE
sync

echo "Attempting to suspend"
do_suspend &
sleep 5
echo "- Attempting to unlock..."

cryptsetup luksResume LUKSDEVICE
