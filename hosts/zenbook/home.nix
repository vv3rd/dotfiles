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
    ./waybar.nix
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
    transmission-qt
    vscodium
    yt-dlp

    # required to create video screen capture
    ffmpeg_6-full
    slop
  ];

  programs.nix-index = {
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

  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 1;
      font.size = 12;
      font.normal.family = "GeistMono Nerd Font";
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
