{ inputs, ... }:
{
  # include.nixos.${inputs.personal.host}.module = {
  #   lol = false;
  # };

  include.nixos.${inputs.personal.host}.module = {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      hostName = "rsndev";
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
        userServices = true;
      };
    };
    networking.firewall.allowedUDPPorts = [ 5353 ];

  };
}
