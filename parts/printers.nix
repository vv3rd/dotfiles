{
  flake.nixosModules.printers =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.simple-scan
      ];

      services.printing.enable = true; # Enable CUPS to print documents.
    };
}
