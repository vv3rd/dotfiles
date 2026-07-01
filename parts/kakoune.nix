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
            pkgs.prettier
            pkgs.prettierd
            pkgs.kakoune
            pkgs.kakoune-lsp
            pkgs.kakoune-cr
            pkgs.kak-tree-sitter
            pkgs.vscode-langservers-extracted
            pkgs.typescript-language-server
            pkgs.nil
            inputs.ttywrap.packages.${system}.default
            inputs.kakansi.packages.${system}.default
          ];
      };
  };
}
