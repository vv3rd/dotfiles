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
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        zenbook = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system; };

          modules = [
            ./zenbook/configuration.nix
            home-manager.nixosModules.default
          ];
        };
      };
    };
}
