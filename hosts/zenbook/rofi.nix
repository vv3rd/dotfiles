{ pkgs, ... }:
{
  home.file.".config/rofi/config.rasi" = {
    source = ./.config-rofi-config.rasi;
  };
  home.packages =
    let
      rofi-with-plugins = pkgs.rofi-wayland.override (old: {
        plugins = [
          pkgs.rofi-emoji-wayland
          pkgs.rofi-calc
        ];
      });
    in
    [
      rofi-with-plugins
    ];
}
