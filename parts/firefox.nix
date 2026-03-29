{ inputs, ... }:
{
  include.nixos.${inputs.personal.myHost}.module = {
    programs.firefox.enable = true;
    environment.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
  };
}
