{ lib, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/nixos/desktop.nix
  ];

  networking.hostName = "mini";
  zramSwap.enable = true;
  system.stateVersion = "26.05";

  hardware.bluetooth = {
    enable = true;
    input.General.ClassicBondedOnly = false;
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  nixpkgs.config.allowUnfreePredicate = pkg: lib.getName pkg == "b43-firmware";
  networking.enableB43Firmware = true;
  boot.blacklistedKernelModules = [ "wl" "brcmsmac" "brcmfmac" ];
}
