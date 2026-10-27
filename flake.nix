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

    noctalia.url = "github:noctalia-dev/noctalia";

    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    noctalia-greeter.inputs.nixpkgs.follows = "nixpkgs";

    pi.url = "github:earendil-works/pi/v1.4.0";
    pi.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, niri, noctalia, noctalia-greeter, pi, ... }:
    let
      mkHome = sharedModules: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "bak";
        home-manager.sharedModules = sharedModules;
        home-manager.users.adhorodyski = import ./modules/home;
      };
    in
    {
      darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/macbook
          { nixpkgs.overlays = [ pi.overlays.default ]; }
          home-manager.darwinModules.home-manager
          (mkHome [ ])
        ];
      };

      nixosConfigurations."mini" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/mini
          ./modules/nixos
          { nixpkgs.overlays = [ pi.overlays.default ]; }
          niri.nixosModules.niri
          noctalia-greeter.nixosModules.default
          home-manager.nixosModules.home-manager
          (mkHome [
            noctalia.homeModules.default
            ./modules/home/linux
          ])
        ];
      };
    };
}
