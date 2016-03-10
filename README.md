Auto-builder for a functional Ubuntu LuksSuspend-to-RAM method.

THERE ARE CAVEATS FOR USE:
- Works as-written with XFS and BTRFS
- ext2, ext3, and ext4 filesystems must use the 'NOBARRIER' options

- Active sessions on vty1-6 will cause the suspend to fail. The script accounts for that by killing all PIDs on VTYs.
- The default options will create, write to, and chroot to /boot/suspend.

To use:
1. Run 'mksuspend.sh <luks_device>'. This can be the short-name or the /dev/mapper/sdXn_crypt
2. Call /boot/suspend/suspend.sh

The host will suspend to RAM. When the host resumes, you will be prompted for the encryption passphrase on vty8. When entered, it will return to the GUI on vty7.
