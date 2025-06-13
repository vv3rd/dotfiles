{
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/terminal.nix
    ../../modules/helix.nix
  ];

  # remove once helix build on mac
  programs.helix.settings.editor.inline-diagnostics = {
    cursor-line = "warning";
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
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Original-Classic";
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
