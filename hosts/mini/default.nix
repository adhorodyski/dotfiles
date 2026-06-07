{ lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/nixos/desktop.nix
  ];

  networking.hostName = "mini";
  zramSwap.enable = true;
  system.stateVersion = "26.05";

  # WiFi: Broadcom BCM4331 (Ivy Bridge Mac Mini) needs the b43 driver firmware.
  # On Ubuntu this was firmware-b43-installer + `modprobe -r b43`; on NixOS the
  # firmware is present at boot, so b43 binds cleanly with no modprobe step.
  # The firmware is unfree (not merely redistributable), so enableRedistributableFirmware
  # does not cover it — allow just this package.
  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "b43-firmware";
  hardware.firmware = [ pkgs.b43Firmware_6_30_163_46 ];
}
