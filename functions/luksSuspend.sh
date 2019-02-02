#! /bin/bash

function do_suspend() {
   #/usr/sbin/pm-suspend
   echo -n "mem" > /sys/power/state
}

function do_lockunlock() {
   echo "Preparing suspend..."
   physlock -l # lock tty switching

   echo "Freezing processes..."
   pkill -STOP --inverse -u 0

   echo "Clearing caches..."
   echo 3 > /proc/sys/vm/drop_caches
   sync
   cryptsetup luksSuspend LUKSDEVICE

   echo "Attempting to suspend"
   do_suspend &
   sleep 1
   echo "- Attempting to unlock..."

   until cryptsetup luksResume LUKSDEVICE; do
      echo "Retrying..."
   done

   echo "Unfreezing processes..."
   pkill -CONT --inverse -u 0

   physlock -L # unlock tty switching
}

sleep 2
do_lockunlock
