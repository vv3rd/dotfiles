
{
    inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    outputs = inputs: (
    let
    	system = "x86_64-linux";
    	pkgs = import inputs.nixpkgs {inherit system;};
    in{
		packages.${system}.default = pkgs.buildGoModule {
            name = "slk";
            src = pkgs.fetchFromGitHub {
                owner = "gammons";
                repo = "slk";
                rev = "v0.8.8";
                hash = "sha256-8F99cvnSBEeM3lDoht6LmyEIxjwxsvIHoLEcjLlt4Bg=";
            };
            vendorHash = "sha256-jstv3EH3e827KXmbKl7d3GBuLNyrpwEQeRpiM/mYSOY=";
            buildInputs = [
                pkgs.libx11
            ];
		};
    });
}

