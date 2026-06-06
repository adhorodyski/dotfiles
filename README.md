# dotfiles

## Prerequisites

This project uses [`nix`](https://nix.dev/). It comes preinstalled on NixOS, otherwise install it following [these guides](https://nix.dev/install-nix#install-nix).

## Getting started

### 1. Clone this repository

```sh
git clone https://github.com/adhorodyski/dotfiles.git ~/Developer/dotfiles
```

### 2. Build and activate

**macOS** (`nix-darwin`):

```sh
cd ~/Developer/dotfiles
nix --extra-experimental-features "nix-command flakes" \
  build .#darwinConfigurations.darwin.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .#darwin
```

**NixOS** (`nix-nixos`):

```sh
cd ~/Developer/dotfiles
sudo nix --experimental-features "nix-command flakes" run \
  github:nix-community/disko -- --mode destroy,format,mount ./hosts/nixos/disko.nix
sudo nixos-generate-config --no-filesystems --root /mnt   # copy result into hosts/nixos/hardware.nix
sudo nixos-install --flake .#nixos
```

## Rebuilds

Use the `nix-rebuild` alias.

## Tools

Terminal: [Ghostty](https://ghostty.org/)

Shell: [Zsh](https://www.zsh.org/), [minimal](https://github.com/subnixr/minimal), [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

Editor: [Neovim](https://neovim.io/), [LazyVim](https://www.lazyvim.org/), [Zenbones](https://github.com/zenbones-theme/zenbones.nvim)

Git: [delta](https://github.com/dandavison/delta), [worktrunk](https://github.com/max-sixty/worktrunk)

Node: [fnm](https://github.com/Schniz/fnm)
