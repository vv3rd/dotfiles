{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module =
    { pkgs, ... }:
    {
      fonts.packages = [
        pkgs.nerd-fonts.geist-mono
        pkgs.nerd-fonts.hack
        pkgs.nerd-fonts.terminess-ttf
      ];
    };
}
