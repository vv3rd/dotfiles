{ inputs, ... }:
{
  include.nixos.${inputs.personal.myHost}.module = {
    services.keyd =
      let
        main = {
          "capslock" = "overload(caplayer, esc)";
        };
        capLayerName = "caplayer:M";
        capLayer = {
          a = "leftalt";
          s = "leftshift";
          d = "leftcontrol";
        };
      in
      {
        enable = true;
        keyboards.default = {
          ids = [ "k:0001:0001" ];
          settings.main = main;
          settings.${capLayerName} = capLayer;
        };
        keyboards.lofree = {
          ids = [
            "k:388d:0001"
            "k:0000:0000:6b654b54"
          ];
          settings.main = main // {
            "esc" = "grave";
            "grave" = "esc";
          };
          settings.${capLayerName} = capLayer;
        };
      };
  };
}
