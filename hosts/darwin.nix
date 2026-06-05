{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  homebrew = {
    enable = true;
    # Each switch, uninstall + zap any brew not declared below (SSOT). --force is
    # required by newer Homebrew to actually perform the destructive cleanup.
    onActivation.cleanup = "zap";
    onActivation.extraFlags = [ "--force" ];
    brews = [ "cocoapods" "rbenv" "watchman" ];
    casks = [ "ghostty" ];
  };

  programs.zsh.enable = true;

  # nix-darwin doesn't create users; it just needs to know the home dir so
  # home-manager can resolve home.homeDirectory.
  users.users.adhorodyski.home = "/Users/adhorodyski";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.primaryUser = "adhorodyski";
  system.stateVersion = 6;
}
