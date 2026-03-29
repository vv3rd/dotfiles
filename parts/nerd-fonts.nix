{
  flake.nixosModules.nerd-fonts =
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
