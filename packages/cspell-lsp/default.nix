{
  pkgs ? import <nixpkgs> { },
}:
let
  cspell-lsp = pkgs.buildNpmPackage rec {
    name = "cspell-lsp";
    pname = "cspell-lsp";

    src = pkgs.fetchFromGitHub {
      owner = "vlabo";
      repo = pname;
      rev = "main";
      hash = "sha256-u9PiaJDm8SapSSfjDU8XnjIzh7njvF9iZ2VAgAzj2ks=";
    };

    postPatch = ''
      npm update
    '';

    makeCacheWritable = true;
    npmDepsHash = "sha256-DIDyuY9NEnzVq/9YVGQumZ36wJnwGg9QL7Rs5kivqig=";
    # The prepack script runs the build script, which we'd rather do in the build phase.
    npmPackFlags = [ "--ignore-scripts" ];
    # npmFlags = [ "--legacy-peer-deps" ];
  };
in
pkgs.mkShell { packages = [ cspell-lsp ]; }
