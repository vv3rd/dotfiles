{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module = {
    home-manager.users.${inputs.personal.name} =
      { pkgs, ... }:
      {
        home.packages =
          let
            system = pkgs.stdenv.hostPlatform.system;
          in
          [
            pkgs.kakoune
            pkgs.kakoune-lsp
            pkgs.kakoune-cr
            pkgs.vscode-langservers-extracted
            pkgs.typescript-language-server
            inputs.ttywrap.packages.${system}.default
            inputs.kakansi.packages.${system}.default
          ];
      };
  };
}
