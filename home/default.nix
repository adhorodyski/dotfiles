{ config, pkgs, lib, ... }:

{
  home.username = "adam";
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
    HOMEBREW_DOWNLOAD_CONCURRENCY = "auto";
  };
  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      g = "git";
      cop = "copilot";
    };
    initExtra = ''
      for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        [ -x "$b" ] && eval "$("$b" shellenv)" && break
      done

      command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init - --no-rehash zsh)"

      eval "$(fnm env --use-on-cd --shell zsh)"

      if command -v wt >/dev/null 2>&1; then eval "$(wt config shell init zsh)"; fi

      source ${pkgs.fetchFromGitHub {
        owner = "subnixr";
        repo = "minimal";
        rev = "6588a399744f34194a25988b4c159cb8b8c67e27";
        hash = lib.fakeHash;
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
    userName = "Adam Horodyski";
    userEmail = "ad.horodyski@gmail.com";
    aliases = {
      s = "status";
      d = "diff";
      dc = "diff --cached";
      l = "log --oneline --decorate";
      wl = "worktree list";
    };
    signing = {
      key = "EAEF5DA3FA0AB923";
      signByDefault = true;
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
      };
    };
    extraConfig = {
      core.editor = "nvim";
      core.autocrlf = false;
      diff.colorMoved = "default";
      push.autoSetupRemote = true;
      branch.sort = "-committerdate";
      init.defaultBranch = "main";
    };
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Developer/dotfiles/.config/nvim";

  xdg.configFile."ghostty/config".source = ./../.config/ghostty/config.ghostty;
  xdg.configFile."worktrunk/config.toml".source = ./../.config/worktrunk/config.toml;
}
