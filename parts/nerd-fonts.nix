{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module =
    { pkgs, ... }:
    {
      fonts.packages = [
        pkgs.nerd-fonts.noto
        pkgs.nerd-fonts.geist-mono
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.hack
      ];
    };
}
