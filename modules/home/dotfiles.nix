{ config, ... }:

{
  xdg.configFile."ghostty/config".source = ./../../.config/ghostty/config.ghostty;
  xdg.configFile."worktrunk/config.toml".source = ./../../.config/worktrunk/config.toml;

  home.file.".agents/AGENTS.md".source = ./../../.agents/AGENTS.md;
  # Pi reads global instructions from here; it ignores ~/.agents/AGENTS.md.
  home.file.".pi/agent/AGENTS.md".source = ./../../.agents/AGENTS.md;

  # Live symlink so skills are editable without a home-manager switch.
  home.file.".agents/skills".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.agents/skills";
}
