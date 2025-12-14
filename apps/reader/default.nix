{
  fetchFromGitHub,
  buildGoModule,
  ...
}:
buildGoModule (final: {
  pname = "reader";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mrusme";
    repo = final.pname;
    rev = "v${final.version}";
    sha256 = "sha256-qu48ikqm4EmoeL9j67tGkX3EFBd1JdrLWhhmoElCoJY=";
  };

  vendorHash = "sha256-8IjN7hm5Rg9ItkxE9pbnkVr5t+tG95W9vvXyGaWmEIA=";
})
