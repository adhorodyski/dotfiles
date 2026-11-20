{ config, ... }:

{
  # Keep the Neovim config out of the Nix store so lazy.nvim can update lazy-lock.json.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.config/nvim";

  xdg.configFile."ghostty/config".source = ./../../.config/ghostty/config.ghostty;

  home.file.".agents/AGENTS.md".source = ./../../.agents/AGENTS.md;
  # Pi reads global instructions from here; it ignores ~/.agents/AGENTS.md.
  home.file.".pi/agent/AGENTS.md".source = ./../../.agents/AGENTS.md;
}
