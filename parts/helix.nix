{ inputs, ... }:
{
  include.nixos.${inputs.personal.myHost}.module = {
    nixpkgs.overlays = [
      (final: prev: {
        helix = inputs.helix.packages.${final.system}.helix;
      })
    ];
  };
}
