# PLACEHOLDER — overwritten on the Mac Mini during install.
#
# Filesystems come from disko.nix, so generate the hardware scan WITHOUT them:
#   sudo nixos-generate-config --no-filesystems --root /mnt
# then copy /mnt/etc/nixos/hardware-configuration.nix over this file. It will
# fill in boot.initrd kernel modules, available modules, and CPU microcode for
# the Ivy Bridge Mini.
{ ... }:

{
}
