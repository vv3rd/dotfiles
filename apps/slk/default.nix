{
    pkgs ? import <nixpkgs> {}
}:
pkgs.buildGoModule {
    name = "slk";
    src = pkgs.fetchFromGitHub {
        owner = "gammons";
        repo = "slk";
        rev = "v0.8.8";
        hash = "sha256-8F99cvnSBEeM3lDoht6LmyEIxjwxsvIHoLEcjLlt4Bg=";
    };
    vendorHash = "";
}
