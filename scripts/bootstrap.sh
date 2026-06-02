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
ZSH_DIR="${ZSH_DIR:-$HOME/.zsh}"

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
    info "not in apt — add these manually: gh, ghostty, fnm, worktrunk"
    return
  fi
}

# --- zsh prompt + plugins (no framework) -----------------------------------
# Sourced directly by .zshrc from ~/.zsh — see that file for load order.
install_zsh_assets() {
  clone https://github.com/subnixr/minimal "$ZSH_DIR/themes/minimal"
  clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_DIR/plugins/zsh-autosuggestions"
  clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_DIR/plugins/zsh-syntax-highlighting"
}

main() {
  install_packages
  install_zsh_assets
  success "bootstrap: done"
}

main "$@"
