{
  writeScriptBin,
  ...
}:
writeScriptBin "powerlimit" # bash

  ''
    # WONT WORK. need sudo.
    echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold
  ''
