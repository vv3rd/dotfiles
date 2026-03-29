{ inputs, ... }:
{
  include.nixos.${inputs.personal.myHost}.module =
    { pkgs, ... }:
    {
      programs.openvpn3 = {
        enable = true;
      };
      services.tailscale.enable = true;

      environment.systemPackages = [
        pkgs.wireguard-tools
      ];
    };
}
