let
  pkgs = import <nixpkgs> { };
in
pkgs.callPackage ./scratchterm.nix { }
