# Brew
HOMEBREW_DOWNLOAD_CONCURRENCY=auto

# Completion (git completion comes from brew's site-functions, on fpath via brew shellenv)
autoload -Uz compinit && compinit

# zsh-native plugins + prompt (no framework). Cloned into ~/.zsh by bootstrap.sh.
ZSH_DIR="$HOME/.zsh"

# Prompt: minimal/mnml theme
source "$ZSH_DIR/themes/minimal/minimal.zsh"

# Recolor the git branch component (overrides the theme's default mnml_git)
function mnml_git {
    local statc="%{\e[0;38;2;230;112;78m%}"
    local bname="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    if [ -n "$bname" ]; then
        printf '%b' "$statc$bname%{\e[0m%}"
    fi
}

# Fish-like history suggestions
source "$ZSH_DIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# User configuration
export EDITOR='nvim'
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias g="git"
alias cop="copilot"

eval "$(fnm env)"

# worktrunk
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# Syntax highlighting MUST be sourced last (after all widgets are defined)
source "$ZSH_DIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
