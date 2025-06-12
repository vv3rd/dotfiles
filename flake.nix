{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix.url = "github:vv3rd/helix/vv3rd-mods";
    niri.url = "github:YaLTeR/niri";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      helix,
      ...
    }@inputs:
    let
      overlay = (
        final: prev: {
          helix = helix.packages.${final.system}.helix;
        }
      );
    in
    {
      nixosConfigurations.zenbook =
        let
          system = "x86_64-linux";
          lib = nixpkgs.lib;
        in
        lib.nixosSystem {
          specialArgs = {
            inherit system inputs;
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
            inherit system helix;
          };
          modules = [ ./hosts/macbook/home.nix ];
        };
    };
}
