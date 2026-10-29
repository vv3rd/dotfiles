{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module = {
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
          ids = [ "k:0001:0001" "k:05ac:024f" ];
          settings.main = main;
          settings.${capLayerName} = capLayer;
        };
        keyboards.lofree = {
          ids = [
            "k:388d:0001" # FIXME: the id might be wrong
            "k:0000:0000:db7f7cbc"
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
