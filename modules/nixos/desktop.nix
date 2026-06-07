{ pkgs, ... }:

{
  # niri Wayland compositor (niri-flake nixos module — provides niri-session,
  # polkit/session integration, and auto-enables niri's Cachix binary cache).
  programs.niri.enable = true;

  # Login: greetd + tuigreet, launching the niri session.
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
      user = "greeter";
    };
  };

  # Audio.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Wayland portals (GTK portal works outside GNOME).
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # GPU (Intel HD 4000 / Mesa — no proprietary driver).
  hardware.graphics.enable = true;

  # Fonts (FiraCode Nerd Font Mono for the terminal/shell).
  fonts.packages = [ pkgs.nerd-fonts.fira-code ];

  # Backend services for Noctalia applets.
  # (NetworkManager is already enabled in modules/nixos/base.nix.)
  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Skip compiling Quickshell — use Noctalia's binary cache.
  nix.settings.extra-substituters = [ "https://noctalia.cachix.org" ];
  nix.settings.extra-trusted-public-keys = [
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
  ];
}
