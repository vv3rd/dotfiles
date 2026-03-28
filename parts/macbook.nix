{ inputs, ... }:
{
  flake.homeConfigurations."alexey" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "aarch64-darwin"; };
    extraSpecialArgs = {
      inherit inputs;
    };
    modules = [ ./hosts/macbook/home.nix ];
  };
}
