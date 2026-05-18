{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module = {
    home-manager.users.${inputs.personal.name} =
      { pkgs, ... }:
      {
        home.packages =
          let
            kakpipe = (pkgs.callPackage ../apps/kakpipe { });
          in
          [
            kakpipe
            pkgs.kakoune
            pkgs.kakoune-lsp
            pkgs.kakoune-cr
            pkgs.vscode-langservers-extracted
            pkgs.typescript-language-server
          ];
      };
  };
}
