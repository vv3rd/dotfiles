{
  flake.nixosModules.silverbullet = args: {
    services.silverbullet = {
      enable = true;
      spaceDir = "/home/${args.user}/Documents/notes";
      user = args.user;
      listenPort = 4300;
    };

  };
}
