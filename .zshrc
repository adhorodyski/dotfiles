# Brew
HOMEBREW_DOWNLOAD_CONCURRENCY=auto

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="minimal"

# auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates

# Performance optimizations
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_AUTO_TITLE="true"
DISABLE_COMPFIX="true"
# disable marking untracked files under VCS as dirty to make large repo statuses fast
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR='nvim'

alias g="git"
alias cop="copilot"

function mnml_git {
    local statc="%{\e[0;38;2;230;112;78m%}"
    local bname="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    if [ -n "$bname" ]; then
        printf '%b' "$statc$bname%{\e[0m%}"
    fi
}

export PATH="$HOME/.local/bin:$PATH"

eval "$(fnm env)"

autoload -Uz add-zsh-hook

_ghostty_tab_title() {
    local name
    name=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) \
        || name=$(git rev-parse --short HEAD 2>/dev/null) \
        || name=${PWD:t}
    printf '\e]2;%s\a' "$name"
}

add-zsh-hook precmd _ghostty_tab_title

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
