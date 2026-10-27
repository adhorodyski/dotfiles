{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    # editor (+ C compiler for nvim-treesitter parsers)
    neovim
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

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.config/nvim";
}
