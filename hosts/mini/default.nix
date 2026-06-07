{ lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/nixos/desktop.nix
  ];

  networking.hostName = "mini";
  zramSwap.enable = true;
  system.stateVersion = "26.05";

  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "b43-firmware";
  hardware.firmware = [ pkgs.b43Firmware_6_30_163_46 ];
}
