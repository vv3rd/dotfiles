{ lib, pkgs, colors, ... }: {
  imports = [ colors.homeManagerModules.default ../../modules/terminal.nix ../../modules/helix.nix ];

  colorScheme = colors.colorSchemes.gruvbox-dark-medium;

  nixpkgs = {
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "discord" "vscode" ];
  };

  home.packages = with pkgs; [
    brave
    discord
    mpc-qt
    signal-desktop
    telegram-desktop
    transmission-qt
    vscode
    yt-dlp

    # required to create video screen capture
    ffmpeg_6-full
    slop
  ];

  programs.nix-index = { enable = true; };

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
      window.opacity = 0.9;
      font.size = 8;
      font.normal.family = "NotoMono Nerd Font";
    };
    settings.keyboard.bindings = [{
      key = "N";
      mods = "Control|Shift";
      action = "SpawnNewInstance";
    }];
  };
}
