{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
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
      home-manager,
      helix,
      colors,
    }:
    let
      helix-overlay = (f: p: { helix = helix.packages.${f.system}.helix; });
    in
    {
      nixosConfigurations.zenbook =
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system colors helix-overlay;
          };
          modules = [
            ./hosts/zenbook/configuration.nix
            home-manager.nixosModules.default
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
