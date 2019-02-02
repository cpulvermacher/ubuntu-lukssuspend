#! /bin/bash

grep -q closed /proc/acpi/button/lid/LID*/state
if [ $? = 0 ]; then
   CHROOTTARGET/suspend.sh;
fi
