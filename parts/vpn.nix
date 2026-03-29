{
  flake.nixosModules.vpn =
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
