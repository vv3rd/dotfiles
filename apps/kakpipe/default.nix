{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "kakpipe";
  version = "0.5.7";
  src = fetchFromGitHub {
    owner = "eburghar";
    repo = "kakpipe";
    rev = "0.5.7";
    hash = "sha256-VjR6Kfbmdjv/tjYue40QP8pnvG3X+lRHwI7ERLvO9xM=";
  };
  cargoHash = "sha256-+kXaW+az02GzIAFh59RhkYLXWVXgEcPKUJ3Q/Gq4qoc=";
}
