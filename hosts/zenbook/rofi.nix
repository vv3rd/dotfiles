{ user }:
{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
    })
  ];

  home-manager.users.${user} = {
    home.file.".config/rofi/config.rasi" = {
      source = ./dotconfig/rofi/config.rasi;
    };
    home.packages = [
      (pkgs.rofi-wayland.override (old: {
        plugins = [
          pkgs.rofi-emoji-wayland
          pkgs.rofi-calc
        ];
      }))
    ];
  };
}
