{ config, ... }:

{
  xdg.configFile."ghostty/config".source = ./../../.config/ghostty/config.ghostty;
  xdg.configFile."worktrunk/config.toml".source = ./../../.config/worktrunk/config.toml;

  home.file.".agents/AGENTS.md".source = ./../../.agents/AGENTS.md;
  home.file.".claude/CLAUDE.md".source = ./../../.claude/CLAUDE.md;
  home.file.".claude/RTK.md".source = ./../../.claude/RTK.md;

  # Live symlink so skills are editable without a home-manager switch.
  home.file.".agents/skills".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.agents/skills";
  home.file.".claude/skills".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/dotfiles/.agents/skills";
}
