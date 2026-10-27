{ ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./editor.nix
    ./cli.nix
    ./dotfiles.nix
  ];

  home.username = "adhorodyski";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
  };
  home.sessionPath = [ "$HOME/.local/bin" ];
}
