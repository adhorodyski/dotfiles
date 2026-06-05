# dotfiles

## Usage

1. Clone this repository

```sh
git clone https://github.com/adhorodyski/dotfiles.git ~/Developer/dotfiles
```

2. Install `nix`

```sh
sh <(curl -L https://nixos.org/nix/install) --daemon
```

3. Build and activate `nix-darwin`

```sh
cd ~/Developer/dotfiles
nix --extra-experimental-features "nix-command flakes" \
  build .#darwinConfigurations.mac.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .#mac
```

Subsequent rebuilds use the `nix-rebuild` alias.

## Platforms

- macOS

## Tools

Terminal: [Ghostty](https://ghostty.org/)

Shell: [Zsh](https://www.zsh.org/), [minimal](https://github.com/subnixr/minimal), [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

Editor: [Neovim](https://neovim.io/), [LazyVim](https://www.lazyvim.org/), [Zenbones](https://github.com/zenbones-theme/zenbones.nvim)

Git: [delta](https://github.com/dandavison/delta), [worktrunk](https://github.com/max-sixty/worktrunk)

Node: [fnm](https://github.com/Schniz/fnm)
