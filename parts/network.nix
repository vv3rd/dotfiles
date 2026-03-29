{
  flake.nixosModules.network =
    { pkgs, host, ... }:
    {
      # essentials
      networking.hostName = host; # Define your hostname.

      # Enable networking
      networking.networkmanager = {
        enable = true;
        plugins = with pkgs; [
          networkmanager-openvpn
        ];
      };

      # for development purposes
      networking.firewall.allowedTCPPorts = [ 8080 ];

    };
}
