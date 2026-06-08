# dotfiles

## Prerequisites

This project uses [`nix`](https://nix.dev/). It comes preinstalled on NixOS, otherwise install it following [these guides](https://nix.dev/install-nix#install-nix).

## Getting started

### 1. Clone this repository

```sh
git clone https://github.com/adhorodyski/dotfiles.git ~/Developer/dotfiles
```

### 2. Build and activate

**macOS** (`nix-darwin`) `macbook`:

```sh
cd ~/Developer/dotfiles
nix --extra-experimental-features "nix-command flakes" \
  build .#darwinConfigurations.macbook.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .#macbook
```

**NixOS** `mini`:

```sh
cd ~/Developer/dotfiles
sudo nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix hosts/mini/hardware.nix
sudo nixos-install --flake .#mini
```

## Rebuilds

Use the `nix-rebuild` alias.

## Tools

Terminal: [Ghostty](https://ghostty.org/)

Shell: [Zsh](https://www.zsh.org/), [minimal](https://github.com/subnixr/minimal), [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

Editor: [Neovim](https://neovim.io/), [LazyVim](https://www.lazyvim.org/), [Zenbones](https://github.com/zenbones-theme/zenbones.nvim)

Git: [delta](https://github.com/dandavison/delta), [worktrunk](https://github.com/max-sixty/worktrunk)

Node: [fnm](https://github.com/Schniz/fnm)
