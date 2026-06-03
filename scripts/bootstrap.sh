#!/usr/bin/env bash
#
# bootstrap.sh — install software the dotfiles depend on.
# dotbot does the symlinking; this only installs/clones.
# Safe to re-run: every step is guarded.
#
# Package source by platform:
#   macOS          -> brew bundle (Brewfile)
#   Debian family  -> apt-get     (pkglist.apt.txt)
# Packages a manager can't provide are logged for manual install.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ZSH_DIR="${ZSH_DIR:-$HOME/.zsh}"

# --- output helpers ---------------------------------------------------------
info() { printf '  ▸ %s\n' "$1"; }
success() { printf '  ✔ %s\n' "$1"; }
warn() { printf '  ! %s\n' "$1" >&2; }

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
# Best-effort: a blocked sudo or unavailable package is logged, not fatal.
# brew bundle handles partial failure itself; apt is atomic, so we feed it one
# package at a time.

# install each package listed in file $1 via command "$2..."; log failures
install_each() {
  local file="$1"
  shift
  local pkg failed=()
  while IFS= read -r pkg; do
    case "$pkg" in ''|\#*) continue ;; esac
    "$@" "$pkg" || failed+=("$pkg")
  done < "$file"
  local f
  for f in "${failed[@]+"${failed[@]}"}"; do
    warn "could not install: $f — please add it manually"
  done
}

apt_install() {
  sudo apt-get update || warn "apt-get update failed — continuing with cached index"
  install_each "$1" sudo apt-get install -y
}

install_packages() {
  if [ "$(uname -s)" = "Darwin" ]; then
    _exists brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
      || { warn "brew install failed — skipping packages"; return 0; }
    info "[brew bundle]"
    brew bundle --file="$DOTFILES/Brewfile" \
      || warn "some brew packages failed — see above; continuing"
    return 0
  fi

  if _exists apt-get; then
    info "[apt install]"
    apt_install "$DOTFILES/pkglist.apt.txt"
    info "not in apt — add these manually: gh, ghostty, fnm, worktrunk"
    return 0
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
