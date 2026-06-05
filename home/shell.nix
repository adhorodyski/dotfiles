{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      g = "git";
      cop = "copilot";
      nix-rebuild =
        if pkgs.stdenv.isDarwin
        then "sudo darwin-rebuild switch --flake $HOME/Developer/dotfiles#darwin"
        else "sudo nixos-rebuild switch --flake $HOME/Developer/dotfiles#nixos";
    };
    profileExtra = lib.optionalString pkgs.stdenv.isDarwin ''
      for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
        [ -x "$b" ] && eval "$("$b" shellenv)" && break
      done

      command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init - --no-rehash zsh)"
    '';
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
}
