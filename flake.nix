{
  description = "Adam's macOS (nix-darwin) config";

  inputs = {
    # Stable release everywhere — security/bug backports flow in on `nix flake
    # update`, no surprise breakage. Every ~6 months bump all three together
    # (26.05 -> 26.11). The home-manager / nix-darwin release MUST match the
    # nixpkgs release — mixing the pair is the #1 way to break a stable setup.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }: {

    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # Move pre-existing dotfiles (the old dotbot symlinks) aside on first
          # activation instead of aborting on collision.
          home-manager.backupFileExtension = "bak";
          home-manager.users.adhorodyski = import ./home/default.nix;
        }
      ];
    };
  };
}
