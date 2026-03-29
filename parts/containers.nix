{ inputs, ... }:
{

  include.nixos.${inputs.personal.host}.module =
    { pkgs, ... }:
    {
      virtualisation.docker = {
        enable = true;

        daemon.settings = {
          bip = "10.221.0.1/24";
          default-address-pools = [
            {
              base = "10.222.0.0/16";
              size = 24;
            }
          ];
        };
      };

      environment.systemPackages = with pkgs; [
        lazydocker
        docker-compose
      ];
    };
}
