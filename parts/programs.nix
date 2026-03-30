{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module =
    { lib, pkgs, ... }:
    let
      freePackages = with pkgs; [
        dig.dnsutils
        inetutils
        wget
        zip
        unzip
        transmission_4-gtk
      ];

      unfreePackages = with pkgs; [
        google-chrome
        android-studio
        android-tools
        slack
      ];

    in
    {
      environment.systemPackages = freePackages ++ unfreePackages;

      nixpkgs.config.android_sdk.accept_license = true;
      # nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate =
        let
          inherit (builtins) elem;
          inherit (lib) getName;
          unfreePackagesNames = (map getName (unfreePackages)) ++ [
            "androidsdk"
          ];
        in
        pkg: elem (getName pkg) unfreePackagesNames;
    };
}
