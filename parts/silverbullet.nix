{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module = args: {
    services.silverbullet = {
      enable = false;
      spaceDir = "/home/${args.user}/Documents/notes";
      user = args.user;
      listenPort = 4300;
    };

  };
}
