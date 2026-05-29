#!/usr/bin/env bash
#
# bootstrap.sh — install software the dotfiles depend on.
# dotbot does the symlinking; this only installs/clones.
# Safe to re-run: every step is guarded.
#
# Package source by platform:
#   macOS          -> brew bundle (Brewfile)
#   Arch family    -> pacman      (pkglist.pacman.txt)
#   Debian family  -> apt-get     (pkglist.apt.txt)
# Packages a manager can't provide are logged for manual install.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# --- output helpers ---------------------------------------------------------
info() { printf '  ▸ %s\n' "$1"; }
success() { printf '  ✔ %s\n' "$1"; }

_exists() { command -v "$1" >/dev/null 2>&1; }

# clone $1 into $2 only if missing
clone() {
  if [ -d "$2" ]; then
    success "exists: $(basename "$2")"
  else
    info "clone: $(basename "$2")"
    git clone --depth=1 "$1" "$2"
  fi
}

# --- package installers -----------------------------------------------------
pacman_install() {
  sudo pacman -S --needed --noconfirm $(grep -v '^#' "$1")
}

apt_install() {
  sudo apt-get update
  sudo apt-get install -y $(grep -v '^#' "$1")
}

install_packages() {
  if [ "$(uname -s)" = "Darwin" ]; then
    _exists brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    info "[brew bundle]"
    brew bundle --file="$DOTFILES/Brewfile"
    return
  fi

  if _exists pacman; then
    info "[pacman install]"
    pacman_install "$DOTFILES/pkglist.pacman.txt"
    info "not in repos — add these manually: fnm"
    return
  fi

  if _exists apt-get; then
    info "[apt install]"
    apt_install "$DOTFILES/pkglist.apt.txt"
    info "not in apt — add these manually: gh, ghostty, fnm"
    return
  fi
}

# --- oh-my-zsh + custom theme/plugins --------------------------------------
install_omz() {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    success "oh-my-zsh present"
  else
    info "install: oh-my-zsh"
    # KEEP_ZSHRC: leave ~/.zshrc alone (dotbot symlinks it)
    # RUNZSH/CHSH=no: don't launch a shell or change the login shell here
    KEEP_ZSHRC=yes RUNZSH=no CHSH=no \
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

install_omz_assets() {
  clone https://github.com/subnixr/minimal "$ZSH_CUSTOM/themes/minimal"
  clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
}

main() {
  install_packages
  install_omz
  install_omz_assets
  success "bootstrap: done"
}

main "$@"
