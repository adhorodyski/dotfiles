{ config, ... }:

{
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Developer/dotfiles/.config/nvim";

  xdg.configFile."ghostty/config".source = ./../.config/ghostty/config.ghostty;
  xdg.configFile."worktrunk/config.toml".source = ./../.config/worktrunk/config.toml;

  home.file.".agents/AGENTS.md".source = ./../.agents/AGENTS.md;
  home.file.".agents/skills".source = ./../.agents/skills;
  home.file.".claude/CLAUDE.md".source = ./../.claude/CLAUDE.md;
  home.file.".claude/skills/grill-me".source = ./../.agents/skills/grill-me;
}
