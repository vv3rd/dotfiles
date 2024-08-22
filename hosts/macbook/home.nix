{
  pkgs,
  config,
  ...
}: {
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

  home.sessionVariables = {
    FLAKE = "${config.home.homeDirectory}/Machine";
    EDITOR = "hx";
    MANROFFOPT = "-c"; # without this man with bat pager outputs escape codes
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    WORDCHARS = "*?_.[]~=&;!#$%^(){}<>";
    DIRENV_LOG_FORMAT = ""; # silences direnv logs
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
