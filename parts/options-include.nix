{
  inputs,
  lib,
  config,
  ...
}:
{
  options.include.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
  };

  config.flake = {
    nixosConfigurations = lib.flip lib.mapAttrs config.include.nixos (
      name:
      { module }:
      lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          user = inputs.personal.myName;
          host = inputs.personal.myHost;
        };
        modules = [ module ];
      }
    );

    # checks =
    #   config.flake.nixosConfigurations
    #   |> lib.mapAttrsToList (
    #     name: nixos: {
    #       ${nixos.config.nixpkgs.hostPlatform.system} = {
    #         "include/nixos/${name}" = nixos.config.system.build.toplevel;
    #       };
    #     }
    #   )
    #   |> lib.mkMerge;
  };
}
