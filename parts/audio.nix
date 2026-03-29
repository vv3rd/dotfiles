{ inputs, ... }:
{
  include.nixos.${inputs.personal.host}.module = {
    services.pulseaudio.enable = false;

    # Enable the RealtimeKit system service, which hands out realtime scheduling priority to user processes on demand.
    # The PulseAudio server uses this to acquire realtime priority.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
