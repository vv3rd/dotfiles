{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module =
    { pkgs, ... }:
    {
      programs.openvpn3 = {
        enable = true;
      };
      services.tailscale.enable = false;

      environment.systemPackages = [
        pkgs.wireguard-tools
      ];
    };
}
