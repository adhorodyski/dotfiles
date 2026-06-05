{ ... }:

{
  imports = [
    ./packages.nix
    ./shell.nix
    ./git.nix
    ./dotfiles.nix
  ];

  home.username = "adhorodyski";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
  };
  home.sessionPath = [ "$HOME/.local/bin" ];
}
