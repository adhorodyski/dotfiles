{ ... }:

{
  xdg.configFile."ghostty/config".source = ./../../.config/ghostty/config.ghostty;

  home.file.".agents/AGENTS.md".source = ./../../.agents/AGENTS.md;
  # Pi reads global instructions from here; it ignores ~/.agents/AGENTS.md.
  home.file.".pi/agent/AGENTS.md".source = ./../../.agents/AGENTS.md;
}
