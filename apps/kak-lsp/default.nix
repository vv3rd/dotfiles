{ pkgs ? import <nixpkgs> {} }:
let
    kak-lsp = pkgs.kakoune-lsp.overrideAttrs (self: {
        patches = self.patches ++ [
            (pkgs.replaceVars ./Hardcode-servers.patch {
                inherit (pkgs) nil typescript-language-server vscode-langservers-extracted;
            })
        ];
    });
in
kak-lsp
