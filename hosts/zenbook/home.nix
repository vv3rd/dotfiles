{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../modules/terminal.nix
    ../../modules/helix.nix
    inputs.vicinae.homeManagerModules.default
  ];

  services.vicinae = {
    enable = true; # default: false
    autoStart = true; # default: true
  };

  home.packages = with pkgs; [
    telegram-desktop
    yt-dlp

    # required to create video screen capture
    ffmpeg_6-full
    slop
  ];

  xdg = {
    enable = true;
  };

  gtk = {
    enable = true;
    theme.package = pkgs.everforest-gtk-theme;
    theme.name = "Everforest-Dark-BL-LB";
    iconTheme.name = "Everforest-Dark";
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Original-Classic";
    cursorTheme.size = 32;
  };

  programs.imv = {
    enable = true;
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

  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "Hack Nerd Font Mono:size=12";
      };
      scrollback = {
        lines = 20000;
      };
      colors = {
        background = "2d353b";
        foreground = "d3c6aa";
        regular0 = "475258"; # black
        regular1 = "e67e80"; # red
        regular2 = "a7c080"; # green
        regular3 = "dbbc7f"; # yellow
        regular4 = "7fbbb3"; # blue
        regular5 = "d699b6"; # magenta
        regular6 = "83c092"; # cyan
        regular7 = "d3c6aa"; # white
        bright0 = "475258"; # bright black
        bright1 = "e67e80"; # bright red
        bright2 = "a7c080"; # bright green
        bright3 = "dbbc7f"; # bright yellow
        bright4 = "7fbbb3"; # bright blue
        bright5 = "d699b6"; # bright magenta
        bright6 = "83c092"; # bright cyan
        bright7 = "d3c6aa"; # bright white
      };
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
