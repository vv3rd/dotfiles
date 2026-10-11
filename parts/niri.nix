{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module =
    {
      inputs,
      pkgs,
      user,
      ...
    }:
    {
      imports = [
          inputs.niri-autoselect-portal.nixosModules.default
      ];

      services.niri-autoselect-portal.enable = true;

      environment.sessionVariables = {
        DISPLAY = ":0";
      };

      programs.niri = {
        enable = true;
        useNautilus = false;
      };

      services.getty = {
        autologinOnce = true;
        autologinUser = user;
      };

      environment.systemPackages =
        let
          system = pkgs.stdenv.hostPlatform.system;
          scratchterm = (pkgs.callPackage ../apps/scratchterm { });
        in
        [
          # pkgs.brightnessctl # don't need with noctalia
          # pkgs.clipse # don't need with noctalia
          inputs.noctalia.packages.${system}.default
          inputs.niri-scratchpad.packages.${system}.niri-scratchpad
          scratchterm
          pkgs.satty
          pkgs.xwayland-satellite
          pkgs.wl-clipboard
          pkgs.keyd

          # portals
          pkgs.xdg-desktop-portal-gtk
          pkgs.xdg-desktop-portal-gnome
          pkgs.xdg-desktop-portal-wlr
        ];

      xdg.portal = {
        enable = true;
        config = {
          niri = {
            default = [ "gnome" ];
            "org.freedesktop.impl.portal.ScreenCast" = ["niri-autoselect" "gnome"];
            "org.freedesktop.impl.portal.Screenshot" = "gnome;gtk;wlr";
          };
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
        ];
      };
    };
}
