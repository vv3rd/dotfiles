{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module =
    { pkgs, ... }:
    {
      programs.localsend = {
        enable = true;
        openFirewall = true;
      };

      hardware.bluetooth.enable = true; # enables support for Bluetooth

      environment.systemPackages = [
        pkgs.bluetuith
      ];
    };
}
