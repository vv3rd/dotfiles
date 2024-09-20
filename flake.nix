{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colors.url = "github:misterio77/nix-colors";
    helix.url = "github:vv3rd/helix/vv3rd-mods";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      helix,
      colors,
      ...
    }@inputs:
    let
      overlay = (
        final: prev: {
          helix = helix.packages.${final.system}.helix;
          telegram-desktop = nixpkgs-unstable.legacyPackages.${final.system}.telegram-desktop;
        }
      );
    in
    {
      nixosConfigurations.zenbook =
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              system
              colors
              inputs
              overlay
              ;
          };
          modules = [
            ./hosts/zenbook/configuration.nix
            home-manager.nixosModules.default
            { nixpkgs.overlays = [ overlay ]; }
          ];
        };

      homeConfigurations."alexey" =
        let
          system = "aarch64-darwin";
          pkgs = import nixpkgs { inherit system; };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit system colors helix;
          };
          modules = [ ./hosts/macbook/home.nix ];
        };
    };
}
