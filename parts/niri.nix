{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module =
    {
      inputs,
      pkgs,
      system,
      user,
      ...
    }:
    {
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

      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.niri-scratchpad.packages.${pkgs.system}.niri-scratchpad
        (pkgs.callPackage ../apps/scratchterm { })
        pkgs.xwayland-satellite
        pkgs.brightnessctl
        pkgs.networkmanagerapplet
        pkgs.clipse
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
            default = [ "gtk" ];
            "org.freedesktop.impl.portal.ScreenCast" = "gnome";
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
