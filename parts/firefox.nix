{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module = {
    programs.firefox.enable = true;
    environment.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
  };
}
