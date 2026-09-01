{ pkgs, ... }:

{
  programs.worktrunk.enable = true;

  home.packages = with pkgs; [
    ripgrep
    tree
    gnupg
    gh
    fnm
    mkcert
    fastfetch
    ffmpeg
  ];
}
