#! /bin/bash

CHROOT_TARGET=CHROOTTARGET
BIND_PATHS="/sys /proc /dev"

## prepare chroot
for p in ${BIND_PATHS}; do
    mount -o bind ${p} ${CHROOT_TARGET}${p}
done

openvt -c 8 -sw -- chroot ${CHROOT_TARGET} /luksSuspend.sh

sleep 1

## unmount chroot bindings
for p in ${BIND_PATHS}; do
    umount ${CHROOT_TARGET}${p}
done
