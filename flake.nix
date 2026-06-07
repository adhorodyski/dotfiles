{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      mkHome = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "bak";
        home-manager.users.adhorodyski = import ./modules/home;
      };

      mkNixos = host: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/${host}
          ./modules/nixos
          home-manager.nixosModules.home-manager
          mkHome
        ];
      };

      mkDarwin = host: nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/${host}
          home-manager.darwinModules.home-manager
          mkHome
        ];
      };
    in
    {
      darwinConfigurations."macbook" = mkDarwin "macbook";
      nixosConfigurations."mini" = mkNixos "mini";
    };
}
