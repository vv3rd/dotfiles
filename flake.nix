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
      overlayModule.nixpkgs.overlays = [
        (final: prev: {
          helix = helix.packages.${final.system}.helix;
          rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
        })
      ];
    in
    {
      nixosConfigurations.zenbook =
        let
          system = "x86_64-linux";
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system inputs;
          };
          modules = [
            ./hosts/zenbook/configuration.nix
            home-manager.nixosModules.default
            overlayModule
          ];
        };

      homeConfigurations."alexey" =
        let
          system = "aarch64-darwin";
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = {
            inherit system inputs;
          };
          modules = [ ./hosts/macbook/home.nix ];
        };
    };
}
