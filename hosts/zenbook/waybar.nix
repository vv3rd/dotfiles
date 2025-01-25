inputs: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        "reload_style_on_change" = true;
        "output" = [ "eDP-1" ];
        "position" = "right";
        "layer" = "top";
        "mode" = "overlay";
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
          "spacing" = 10;
        };
        "battery" = {
          "format" = " {icon} \n{capacity:3}";
          "format-icons" = [
            "󰂎"
            "󱊡"
            "󱊢"
            "󱊣"
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
        "pulseaudio" = {
          "format" = " {icon} \n{volume:3}";
          "format-bluetooth" = "{icon} \n{volume:3}";
          "format-icons" = {
            "default" = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
            "headphones" = "󰋋";
          };
          "format-muted" = "󰝟";
          "scroll-step" = 5;
        };
      };
    };
  };
}
