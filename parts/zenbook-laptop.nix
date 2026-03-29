{ inputs, self, ... }:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.nixosConfigurations.${inputs.personal.myHost} = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      user = inputs.personal.myName;
      host = inputs.personal.myHost;
    };
    modules =
      (with self.nixosModules; [
        essentials
        helix-overlay
        nerd-fonts
        firefox
        thunar
        containers
        audio
        printers
        silverbullet
      ])
      ++ [
        ../hosts/zenbook/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
  };

  flake.nixosModules.essentials =
    { config, user, ... }:
    {
      # create a "system" alias for everything in current system
      # e.g. nix run system\#<package>
      nix.registry = {
        system.flake = inputs.self;
      };
      # Creates read-only source of this repo that produced
      # the currently running system
      environment.etc."current-flake".source = inputs.self;

      programs.nh = {
        enable = true;
        flake = "${config.users.users.${user}.home}/Machine";
      };

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.users.${user} = {
        home.stateVersion = "25.05";
        programs.home-manager.enable = true;
        imports = [
          ../hosts/zenbook/home.nix
        ];
      };

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "23.05"; # Did you read the comment?
    };

  flake.nixosModules.helix-overlay = {
    nixpkgs.overlays = [
      (final: prev: {
        helix = inputs.helix.packages.${final.system}.helix;
      })
    ];
  };
}
