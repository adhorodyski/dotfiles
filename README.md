# dotfiles

## Usage

1. Clone this repository.

```sh
git clone https://github.com/adhorodyski/dotfiles.git ~/Developer/dotfiles
```

1. Install `Nix`.

```sh
sh <(curl -L https://nixos.org/nix/install) --daemon
echo "extra-experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
```

1. Build and activate `nix-darwin`.

```sh
cd ~/Developer/dotfiles
nix build .#darwinConfigurations.mac.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .#mac
```

## Platforms

- macOS

## Tools

Terminal: [Ghostty](https://ghostty.org/)

Shell: [Zsh](https://www.zsh.org/), [minimal](https://github.com/subnixr/minimal), [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

Editor: [Neovim](https://neovim.io/), [LazyVim](https://www.lazyvim.org/), [Zenbones](https://github.com/zenbones-theme/zenbones.nvim)

Git: [delta](https://github.com/dandavison/delta), [worktrunk](https://github.com/max-sixty/worktrunk)

Node: [fnm](https://github.com/Schniz/fnm)
