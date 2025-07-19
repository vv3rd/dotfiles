{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix.url = "github:vv3rd/helix/vv3rd-mods";
    # niri.url = "github:YaLTeR/niri";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      quickshell,
      ...
    }@inputs:
    let
      overlayModule.nixpkgs.overlays = [
        (final: prev: {
          helix = inputs.helix.packages.${final.system}.helix;
          rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
          quickshell = quickshell.packages.${final.system}.default;
        })
      ];
    in
    {
      nixosConfigurations."zenbook" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/zenbook/configuration.nix
          home-manager.nixosModules.default
          overlayModule
        ];
      };

      homeConfigurations."alexey" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "aarch64-darwin"; };
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [ ./hosts/macbook/home.nix ];
      };
    };
}
