{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.colors.homeManagerModules.default
    ../../modules/terminal.nix
    ../../modules/helix.nix
  ];

  colorScheme = inputs.colors.colorSchemes.gruvbox-dark-medium;

  # remove once helix build on mac
  programs.helix.settings.editor.inline-diagnostics = {
    cursor-line = "warning";
  };

  nixpkgs = {
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "discord"
        "vscode"
      ];
  };

  home.packages = with pkgs; [
    telegram-desktop
    transmission_3-gtk
    xfce.thunar
    vscodium
    yt-dlp

    # required to create video screen capture
    ffmpeg_6-full
    slop
  ];

  gtk = {
    enable = true;
    theme.package = pkgs.everforest-gtk-theme;
    theme.name = "Everforest-Dark-BL-LB";
    iconTheme.name = "Everforest-Dark";
    cursorTheme.package = pkgs.vimix-cursor-theme;
    cursorTheme.name = "Vimix-Cursors";
    cursorTheme.size = 32;
  };

  programs.mpv = {
    enable = true;
    config = {
      save-position-on-quit = true;
      autofit-larger = "100%x100%";
      sub-scale = 0.4;
      sub-scale-by-window = "no";
      audio-file-auto = "fuzzy";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 1;
      font.size = 12;
      font.normal.family = "GeistMono Nerd Font";
      general.import = [
        "~/.config/alacritty/themes/everforest-dark.toml"
      ];
    };
    settings.keyboard.bindings = [
      {
        key = "N";
        mods = "Control|Shift";
        action = "SpawnNewInstance";
      }
      {
        key = "J";
        mods = "Control|Shift";
        action = "ToggleViMode";
      }
    ];
  };
}
