{ config, pkgs, lib, ... }:

{
  home.username = "adhorodyski";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    neovim
    ripgrep
    tree
    gnupg
    gh
    fnm
    worktrunk
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_US.UTF-8";
  };
  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      g = "git";
      cop = "copilot";
      nix-rebuild = "sudo darwin-rebuild switch --flake $HOME/Developer/dotfiles#mac";
    };
    # Login-shell env (.zprofile). brew first so its PATH prepend wins after
    # /etc/zprofile's path_helper; rbenv after, since it's brew-installed.
    # Runs once per login, not on every interactive shell.
    profileExtra = ''
      for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        [ -x "$b" ] && eval "$("$b" shellenv)" && break
      done

      command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init - --no-rehash zsh)"
    '';
    # initContent replaces the removed initExtra on 26.05 (default order 1000).
    initContent = ''
      eval "$(fnm env --use-on-cd --shell zsh)"

      if command -v wt >/dev/null 2>&1; then eval "$(wt config shell init zsh)"; fi

      source ${pkgs.fetchFromGitHub {
        owner = "subnixr";
        repo = "minimal";
        rev = "6588a399744f34194a25988b4c159cb8b8c67e27";
        hash = "sha256-r5AIk7TzXQ5x+mXRA6isWCn0FvmICeFR36k5Kq4s+Yk=";
      }}/minimal.zsh

      function mnml_git {
          local statc="%{\e[0;38;2;230;112;78m%}"
          local bname="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
          if [ -n "$bname" ]; then
              printf '%b' "$statc$bname%{\e[0m%}"
          fi
      }
    '';
  };

  programs.git = {
    enable = true;
    signing = {
      key = "EAEF5DA3FA0AB923";
      signByDefault = true;
    };
    # settings is the freeform gitconfig (replaces userName/userEmail/aliases/
    # extraConfig, all merged here as of 26.05).
    settings = {
      user.name = "Adam Horodyski";
      user.email = "ad.horodyski@gmail.com";
      alias = {
        s = "status";
        d = "diff";
        dc = "diff --cached";
        l = "log --oneline --decorate";
        wl = "worktree list";
      };
      core.editor = "nvim";
      core.autocrlf = false;
      diff.colorMoved = "default";
      push.autoSetupRemote = true;
      branch.sort = "-committerdate";
      init.defaultBranch = "main";
    };
  };

  # delta is its own module now (was programs.git.delta). enableGitIntegration
  # wires it in as core.pager — without it, 26.05 no longer does so automatically.
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
    };
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    extraOptions = [ "--no-user" "--no-time" "--git-ignore" ];
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Developer/dotfiles/.config/nvim";

  xdg.configFile."ghostty/config".source = ./../.config/ghostty/config.ghostty;
  xdg.configFile."worktrunk/config.toml".source = ./../.config/worktrunk/config.toml;

  # Agent CLI config. This repo's .agents/ is the single source of truth, fanned
  # out to each CLI. .agents/skills feeds Copilot + Gemini; Claude Code reads
  # ~/.claude/skills only, so grill-me is linked per-skill to avoid clobbering
  # machine-local Claude skills.
  home.file.".agents/AGENTS.md".source = ./../.agents/AGENTS.md;
  home.file.".agents/skills".source = ./../.agents/skills;
  home.file.".claude/CLAUDE.md".source = ./../.claude/CLAUDE.md;
  home.file.".claude/skills/grill-me".source = ./../.agents/skills/grill-me;
}
