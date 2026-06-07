{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    noctalia.url = "github:noctalia-dev/noctalia-shell";
    noctalia.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, niri, noctalia, ... }:
    let
      mkHome = sharedModules: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "bak";
        home-manager.sharedModules = sharedModules;
        home-manager.users.adhorodyski = import ./modules/home;
      };

      mkNixos = host: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/${host}
          ./modules/nixos
          niri.nixosModules.niri
          home-manager.nixosModules.home-manager
          (mkHome [
            noctalia.homeModules.default
            ./modules/home/linux
          ])
        ];
      };

      mkDarwin = host: nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/${host}
          home-manager.darwinModules.home-manager
          (mkHome [ ])
        ];
      };
    in
    {
      darwinConfigurations."macbook" = mkDarwin "macbook";
      nixosConfigurations."mini" = mkNixos "mini";
    };
}
