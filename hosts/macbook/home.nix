{ pkgs, config, ... }:
{
  home.username = "alexey";
  home.homeDirectory = "/Users/alexey";

  home.stateVersion = "23.11";

  imports = [
    ../../modules/helix.nix
    ../../modules/terminal.nix
  ];

  xdg = {
    enable = true;
  };

  home.packages = [
    pkgs.ffmpeg-full
    pkgs.nodejs
    pkgs.nodejs.pkgs.pnpm
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.9;
      font.size = 8;
      font.normal.family = "NotoMono Nerd Font";
    };
    settings.window.options_as_alt = "Both";
    settings.keyboard.bindings = [
      {
        key = "N";
        mods = "Control|Shift";
        action = "SpawnNewInstance";
      }
    ];
  };

  home.sessionVariables = {
    FLAKE = "${config.home.homeDirectory}/Machine";
    # EDITOR = "hx";
    # MANROFFOPT = "-c"; # without this man with bat pager outputs escape codes
    # MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    # WORDCHARS = "*?_.[]~=&;!#$%^(){}<>";
    # DIRENV_LOG_FORMAT = ""; # silences direnv logs
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
