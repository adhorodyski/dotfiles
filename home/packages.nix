{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    ripgrep
    tree
    gnupg
    gh
    fnm
    worktrunk
    mkcert
  ];

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    extraOptions = [ "--no-user" "--no-time" "--git-ignore" ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
