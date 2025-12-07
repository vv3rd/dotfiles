{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix.url = "github:vv3rd/helix/vv3rd-mods";
    # niri.url = "github:YaLTeR/niri";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      noctalia,
      self,
      ...
    }@inputs:
    let
      overlayModule.nixpkgs.overlays = [
        (final: prev: {
          helix = inputs.helix.packages.${final.system}.helix;
          # quickshell = quickshell.packages.${final.system}.default;
        })
      ];
    in
    {
      nixosConfigurations."zenbook" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs self;
        };
        modules = [
          ./hosts/zenbook/configuration.nix
          home-manager.nixosModules.default
          overlayModule
        ];
      };

      homeConfigurations."alexey" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "aarch64-darwin"; };
        extraSpecialArgs = {
          inherit inputs self;
        };
        modules = [ ./hosts/macbook/home.nix ];
      };
    };

  nixConfig = {
    extra-substituters = [
      "https://vicinae.cachix.org"
      "https://helix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
    ];
  };

}
