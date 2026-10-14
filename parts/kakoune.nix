{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module = {
    home-manager.users.${inputs.personal.name} =
      { pkgs, ... }:
      {
        home.packages =
          let
            system = pkgs.stdenv.hostPlatform.system;

            tools = mkTools pkgs;
            mkTools =
              pkgs: with pkgs; [
                vscode-langservers-extracted
                typescript-language-server
                vtsls
                nil
                typescript-go
                prettier
                prettierd
              ];

            zed = pkgs.zed-editor.fhsWithPackages mkTools;
          in
          [
            zed
            pkgs.kakoune
            pkgs.kakoune-lsp
            pkgs.kakoune-cr
            pkgs.kak-tree-sitter
            pkgs.vtsls
            inputs.ttywrap.packages.${system}.default
            inputs.kakansi.packages.${system}.default
          ]
          ++ tools;
      };
  };
}
