{ pkgs, ... }:

{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.extraFlags = [ "--force" ];
    taps = [ "rtk-ai/tap" ];
    brews = [ "cocoapods" "rbenv" "watchman" "rtk-ai/tap/rtk" ];
    casks = [ "ghostty" ];
  };

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  programs.zsh.enable = true;

  users.users.adhorodyski.home = "/Users/adhorodyski";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.primaryUser = "adhorodyski";
  system.stateVersion = 6;
}
