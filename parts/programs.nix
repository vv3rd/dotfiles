{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module =
    { lib, pkgs, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;
      unstable = import inputs.unstable {
         inherit system;
         config.android_sdk.accept_license = true;
         config.allowUnfree = true;
      };

      freePackages = with pkgs; [
        dig.dnsutils
        inetutils
        wget
        zip
        unzip
        mitmproxy
        transmission_4-gtk
        copyparty
      ];

      unfreePackages = with pkgs; [
        google-chrome
        unstable.android-studio
        unstable.android-tools
        slack
      ];

    in
    {
      environment.systemPackages = freePackages ++ unfreePackages;

      nixpkgs.config.android_sdk.accept_license = true;
      nixpkgs.config.allowUnfree = true;
      # nixpkgs.config.allowUnfreePredicate =
      #   let
      #     inherit (builtins) elem;
      #     inherit (lib) getName;
      #     unfreePackagesNames = (map getName (unfreePackages)) ++ [
      #       "androidsdk"
      #     ];
      #   in
      #   pkg: elem (getName pkg) unfreePackagesNames;
    };
}
