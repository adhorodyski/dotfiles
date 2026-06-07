{ lib, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/nixos/desktop.nix
  ];

  networking.hostName = "mini";
  zramSwap.enable = true;
  system.stateVersion = "26.05";

  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "b43-firmware";
  networking.enableB43Firmware = true;
  boot.blacklistedKernelModules = [ "wl" "brcmsmac" "brcmfmac" ];
}
