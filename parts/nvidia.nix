{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module =
    { config, ... }:
    {

      hardware.graphics = {
        enable = true;
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        open = false;

        prime = {
          sync.enable = true;

          intelBusId = "PCI:0@0:2:0";
          nvidiaBusId = "PCI:2@0:0:0";
        };

        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };
}
