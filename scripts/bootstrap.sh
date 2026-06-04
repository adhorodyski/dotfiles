#!/usr/bin/env bash
#
# bootstrap.sh — install software the dotfiles depend on.
# dotbot does the symlinking; this only installs/clones.
# Safe to re-run: every step is guarded.
#
# Package source: Homebrew on both platforms (brew bundle + Brewfile).
# On Debian/Ubuntu, brew's build prerequisites are installed via apt first.

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
# Best-effort: a blocked sudo or failed package is logged, not fatal.
# brew bundle handles partial failure itself.

# Homebrew build prerequisites on Debian/Ubuntu. brew compiles formulae against
# a system toolchain, so these must exist before the installer runs. Fixed
# one-time list; `apt-get install` is idempotent for packages already present.
apt_prereqs() {
  sudo apt-get update || warn "apt-get update failed — continuing with cached index"
  sudo apt-get install -y build-essential procps curl file git \
    || warn "could not install some Homebrew prerequisites — brew install may fail"
}

install_packages() {
  if [ "$(uname -s)" != "Darwin" ] && _exists apt-get; then
    info "[apt: Homebrew prerequisites]"
    apt_prereqs
  fi

  if ! _exists brew; then
    info "installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
      || { warn "brew install failed — skipping packages"; return 0; }
  fi

  # Load brew into this non-interactive shell — .zprofile isn't sourced here, so
  # a freshly-installed brew won't be on PATH yet.
  local b
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew \
           /home/linuxbrew/.linuxbrew/bin/brew "$HOME/.linuxbrew/bin/brew"; do
    [ -x "$b" ] && eval "$("$b" shellenv)" && break
  done

  _exists brew || { warn "brew not on PATH after install — skipping packages"; return 0; }

  info "[brew bundle]"
  brew bundle --file="$DOTFILES/Brewfile" \
    || warn "some brew packages failed — see above; continuing"
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
