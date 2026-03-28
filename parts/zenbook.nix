{ inputs, ... }:
{
  flake.nixosConfigurations."zenbook" = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
    };
    modules =
      let
        overlay.nixpkgs.overlays = [
          (final: prev: {
            helix = inputs.helix.packages.${final.system}.helix;
          })
        ];
      in
      [
        ../hosts/zenbook/configuration.nix
        inputs.home-manager.nixosModules.default
        overlay
      ];
  };
}
