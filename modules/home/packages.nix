{ pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    # C compiler for nvim-treesitter parsers
    gcc
    ripgrep
    tree
    gnupg
    gh
    fnm
    mkcert
    fastfetch
    pi
    ffmpeg
  ];

  home.sessionVariables.EDITOR = "nvim";
}
