{ pkgs, config, ... }:

{
  home.packages = [
    pkgs.neovim
    pkgs.gcc # C compiler for nvim-treesitter parsers
  ];

  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.config/nvim";
}
