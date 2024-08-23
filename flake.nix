{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    colors,
  }: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    zenbookConfig = ./hosts/zenbook/configuration.nix;
  in {
    nixosConfigurations = {
      zenbook = lib.nixosSystem {
        specialArgs = {inherit system colors;};

        modules = [zenbookConfig home-manager.nixosModules.default];
      };
    };

    homeConfigurations."alexey" = let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
      };
      person = {
        email = "a.lyudskoy@raison.finance";
        name = "Alexey Lyudskoy";
        timeZone = "Asia/Almaty";
      };
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit person;};
        modules = [./hosts/macbook/home.nix];
      };
  };
}
