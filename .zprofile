# Login-shell environment. Each block guards on the tool existing so this file
# is safe to symlink onto machines that don't have all of them.

# Brew (macOS only — no-ops anywhere brew isn't installed). Runs after
# /etc/zprofile's path_helper, so its PATH prepend wins.
for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [ -x "$b" ] && eval "$("$b" shellenv)" && break
done

# rbenv (Ruby version manager; installed via brew, so after the block above)
command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init - --no-rehash zsh)"
