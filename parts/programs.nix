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
        mitmproxy
        transmission_4-gtk
        # copyparty
      ];

      unfreePackages = with pkgs; [
        google-chrome
        slack
      ];

    in
    {
      environment.systemPackages = freePackages ++ unfreePackages;

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
