{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      zenbookConfig = ./hosts/zenbook/configuration.nix;
    in {
      nixosConfigurations = {
        zenbook = lib.nixosSystem {
          specialArgs = { inherit system; };

          modules = [ zenbookConfig home-manager.nixosModules.default ];
        };
      };
    };
}
