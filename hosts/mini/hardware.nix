# PLACEHOLDER — overwritten on the Mac Mini during install.
#
# Partition manually in the installer (boot SSD: ESP + root; data HDD at /data),
# then copy the installer's full hardware scan over this file:
#   cp /mnt/etc/nixos/hardware-configuration.nix hosts/mini/hardware.nix
# It carries the fileSystems mounts plus boot.initrd kernel modules, available
# modules, and CPU microcode for the Ivy Bridge Mini.
{ ... }:

{
}
