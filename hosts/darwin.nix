{ pkgs, ... }:

{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.extraFlags = [ "--force" ];
    brews = [ "cocoapods" "rbenv" "watchman" ];
    casks = [ "ghostty" ];
  };

  programs.zsh.enable = true;

  users.users.adhorodyski.home = "/Users/adhorodyski";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.primaryUser = "adhorodyski";
  system.stateVersion = 6;
}
