{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  # ⚠️ Broadcom WiFi on the Late-2012 Mac Mini needs non-free firmware
  hardware.enableRedistributableFirmware = true;
  # boot.kernelModules = [ "wl" ]; + broadcom_sta if b43 won't cut it

  # Intel HD 4000 (Ivy Bridge) — supported by Mesa, just enable graphics
  hardware.graphics.enable = true;

  networking.hostName = "homelab";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  users.users.adam = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    initialPassword = "changeme";
  };
  programs.zsh.enable = true;

  services.openssh.enable = true;

  environment.systemPackages = [ pkgs.git ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "26.05";
}
