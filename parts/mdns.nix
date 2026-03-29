{ inputs, ... }:
{
  # include.nixos.${inputs.personal.myHost}.module = {
  #   lol = false;
  # };

  include.nixos.${inputs.personal.myHost}.module = {
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
