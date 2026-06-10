{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableRedistributableFirmware = true;

  networking.networkmanager.enable = true;

  users.users.adhorodyski = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  virtualisation.docker.enable = true;
  environment.systemPackages = [ pkgs.docker-compose ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
