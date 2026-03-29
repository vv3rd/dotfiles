{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module = {
    nixpkgs.overlays = [
      (final: prev: {
        helix = inputs.helix.packages.${final.system}.helix;
      })
    ];
  };
}
