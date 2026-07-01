{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module =
    { pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
    in
    {
      services.ollama = {
        enable = true;
        package = inputs.unstable.legacyPackages.${system}.ollama;
      };
    };
}
