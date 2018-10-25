#! /bin/bash

function do_suspend() {
   #/usr/sbin/pm-suspend
   echo -n "mem" > /sys/power/state
}

function do_lockunlock() {
   sync
   cryptsetup luksSuspend LUKSDEVICE

   echo "Attempting to suspend"
   do_suspend &
   sleep 1
   echo "- Attempting to unlock..."

   cryptsetup luksResume LUKSDEVICE
}

sleep 2
do_lockunlock
