{ ... }:

{
  xdg.configFile."ghostty/config".source = ./../../.config/ghostty/config.ghostty;
  xdg.configFile."worktrunk/config.toml".source = ./../../.config/worktrunk/config.toml;

  home.file.".agents/AGENTS.md".source = ./../../.agents/AGENTS.md;
  home.file.".agents/skills".source = ./../../.agents/skills;
  home.file.".claude/output-styles".source = ./../../.claude/output-styles;
  home.file.".claude/CLAUDE.md".source = ./../../.claude/CLAUDE.md;
  home.file.".claude/RTK.md".source = ./../../.claude/RTK.md;
  home.file.".claude/skills/caveman".source = ./../../.agents/skills/caveman;
  home.file.".claude/skills/read-issue".source = ./../../.agents/skills/read-issue;
  home.file.".claude/skills/read-pr".source = ./../../.agents/skills/read-pr;
  home.file.".claude/skills/decomment".source = ./../../.agents/skills/decomment;
}
