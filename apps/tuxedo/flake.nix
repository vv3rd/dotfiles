{
    inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    outputs = inputs: {
		packages.x86_64-linux =
		let
			pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
		in {
            default = pkgs.callPackage ./default.nix {};
		};
    };
}
