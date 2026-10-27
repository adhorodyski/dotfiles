{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
}
