{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  homebrew = {
    enable = true;
    brews = [ "cocoapods" "rbenv" "watchman" ];
    casks = [ "ghostty" ];
  };

  programs.zsh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = 6;
}
