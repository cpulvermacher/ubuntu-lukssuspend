Auto-builder for a functional Ubuntu LuksSuspend-to-RAM method.

## Caveats
- Works as-written with XFS and BTRFS
- ext2, ext3, and ext4 filesystems must use the 'NOBARRIER' options
- Active sessions on vty1-6 will cause the suspend to fail. The script accounts for that by killing all PIDs on VTYs.
- The default options will create, write to, and chroot to /boot/suspend.

## Usage
- Run 'mksuspend.sh &lt;luks_device&gt;'. This can be the short-name or the /dev/mapper/sdXn_crypt<br>
- Call /boot/suspend/suspend.sh<br><br>

After a few second delay, the host will suspend to RAM. When the host resumes, you will be prompted for the encryption passphrase on vty8. When entered, it will return to calling process.
