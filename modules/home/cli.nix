{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    tree
    gnupg
    gh
    fnm
    worktrunk
    mkcert
  ];
}
