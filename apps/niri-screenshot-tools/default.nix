{
    rustPlatform,
    fetchFromCodeberg,
}:
rustPlatform.buildRustPackage {
    name = "niri-screenshot-tools";
    src = fetchFromCodeberg {
		owner = "whenthesilly";
		repo = "niri-screenshot-tools";
		rev = "main";
		hash = "sha256-dtVs1vaan+eqXTXk+DDz/rP/gZtqZycEaKBjl0NlnU8=";
    };
    cargoHash = "sha256-jD788VSI8Px2Rg6kcz677aq0QKq8KlDBT+9NxrNZDgA=";
}
