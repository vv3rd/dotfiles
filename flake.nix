{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colors.url = "github:misterio77/nix-colors";
    helix.url = "github:vv3rd/helix/vv3rd-mods";
    xremap.url = "github:xremap/nix-flake";
    niri.url = "github:YaLTeR/niri";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      helix,
      colors,
      xremap,
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
          unfreePkgs = [
            "discord"
            "vscode"
          ];
        in
        lib.nixosSystem {
          specialArgs = {
            inherit system inputs;
          };
          modules = [
            ./hosts/zenbook/configuration.nix
            home-manager.nixosModules.default
            xremap.nixosModules.default
            {
              nixpkgs.overlays = [ overlay ];
              nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfreePkgs;
            }
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
