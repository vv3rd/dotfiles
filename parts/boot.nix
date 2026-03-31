{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module = {
    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 8;
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
