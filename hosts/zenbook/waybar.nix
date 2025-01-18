inputs: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        "reload_style_on_change" = true;
        "output" = [ "eDP-1" ];
        "position" = "right";
        "layer" = "top";
        "margin" = "10 10 10 0";
        "modules-right" = [
          "tray"
          "pulseaudio"
          "battery"
          "niri/language"
          "clock"
        ];
        "niri/language" = {
          "format" = "<span text_transform='uppercase'>{short}</span>";
        };
        "tray" = {
          "icon-size" = 22;
        };
        "battery" = {
          "format" = "{icon}\n{capacity}";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
          "states" = {
            "critical" = 15;
            "good" = 95;
            "warning" = 30;
          };
        };
        "clock" = {
          "format" = "{:%H\n%M}";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          "calendar" = {
            "mode" = "month";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "format" = {
              "today" = "<span color='#a6e3a1'><b><u>{}</u></b></span>";
            };
          };
        };
        "cpu" = {
          "format" = "\n{usage:2}";
          "interval" = 5;
        };
        "memory" = {
          "format" = "\n{}";
          "interval" = 5;
        };
        "pulseaudio" = {
          "format" = "{icon}\n{volume:2}";
          "format-bluetooth" = "{icon}\n{volume}%";
          "format-icons" = {
            "default" = [
              ""
              ""
            ];
            "headphones" = "";
          };
          "format-muted" = "MUTE";
          "scroll-step" = 5;
        };
      };
    };
  };
}
