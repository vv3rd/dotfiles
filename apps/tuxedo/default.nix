{
    rustPlatform,
    fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
    name = "tuxedo";
    src = fetchFromGitHub {
		owner = "webstonehq";
		repo = "tuxedo";
		rev = "v2026.5.12";
		hash = "sha256-s4GIHq4kjj+FiNBJJjWeXmg4f40ARUILzwsEl0CDV1o=";
    };
    cargoHash = "sha256-rIdjrwNuY0DySdk4jc880JrFgoIuKTYEcx6XoSfllp4=";
      checkFlags = [
        "--skip=list_grouped_by_due"
      ];
}
