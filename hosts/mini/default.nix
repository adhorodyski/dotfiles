{ ... }:

{
  imports = [
    ./hardware.nix
    ./disko.nix
  ];

  networking.hostName = "mini";
  zramSwap.enable = true;
  system.stateVersion = "26.05";
}
