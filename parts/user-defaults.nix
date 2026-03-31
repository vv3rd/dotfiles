{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module =
    { pkgs, ... }:
    {
      environment.sessionVariables = {
        TERMINAL = "${pkgs.foot}/bin/footclient";
      };

      xdg.terminal-exec = {
        enable = true;
        settings = {
          default = [ "Foot.desktop" ];
        };
      };

      # settings ZSH as default
      environment.shells = [ pkgs.zsh ];
      # Many programs look at /etc/shells to determine if a user is a "normal" user and not a "system" user.
      programs.zsh.enable = true;
    };

}
