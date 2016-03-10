#! /bin/bash
sync
cryptsetup luksSuspend LUKSDEVICE
sync

#/usr/sbin/pm-suspend
echo -n "mem" > /sys/power/state

cryptsetup luksResume LUKSDEVICE
