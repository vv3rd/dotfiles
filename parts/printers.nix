{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.simple-scan
      ];

      services.printing.enable = true; # Enable CUPS to print documents.
    };
}
