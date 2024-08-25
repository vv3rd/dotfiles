# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
let
  user = "odmin";

  configuration = { config, pkgs, lib, colors, system, helix, ... }: {
    imports = [
      ./hardware-configuration.nix

      module_essentials
      module_user
      module_audio
      module_desktop-Plasma
      # module_keyboard
      module_browser-Firefox
      module_locale
      module_containers
    ];

    programs.openvpn3.enable = true;

    documentation.dev.enable = true;

    environment.systemPackages = with pkgs; [
      #
      nh
      dig.dnsutils
      stow
      wget
    ];

    home-manager.extraSpecialArgs = {
      inherit colors system helix;
    };
    home-manager.users.${user} = { pkgs, ... }: {
      home.stateVersion = "23.05";
      programs.home-manager.enable = true;
      imports = [ ./home.nix ];
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?
  };

  module_keyboard = { ... }: {
    services.kanata.enable = true;
    services.kanata.keyboards.default.config = ''
      (defsrc caps )
      (defalias escctrl (tap-hold 100 100 esc lctl) )
      (deflayer base @escctrl )'';
  };

  module_essentials = { ... }: {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking.hostName = "zenbook"; # Define your hostname.
    networking.networkmanager.enable = true; # Enable networking
    services.printing.enable = true; # Enable CUPS to print documents.
    hardware.bluetooth.enable = true; # enables support for Bluetooth

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };

  module_user = { pkgs, ... }: {
    environment.sessionVariables = {
      FLAKE = "/home/${user}/Machine";
      # home dir cleanup
      XCOMPOSECACHE = "$HOME/.cache/compose-cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc-2.0";
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.odmin = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "docker" ];
    };

    # settings ZSH as default
    users.users.odmin.shell = pkgs.zsh;
    environment.shells = [ pkgs.zsh ];
    # Many programs look at /etc/shells to determine if a user is a "normal" user and not a "system" user.
    programs.zsh.enable = true;
  };

  module_desktop-Plasma = { pkgs, ... }: {
    fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "Noto" ]; }) ];

    # Disable drag release delay
    services.libinput.touchpad.tappingDragLock = false;

    services.displayManager.sddm.enable = true;

    services.xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Enable the KDE Plasma Desktop Environment.
      desktopManager.plasma5.enable = true;

      # Configure keymap in X11
      xkb.layout = "us";
      xkb.variant = "";
    };
  };

  module_browser-Firefox = { ... }: {
    programs.firefox.enable = true;
    environment.sessionVariables = { MOZ_USE_XINPUT2 = "1"; };
  };

  module_locale = { ... }: {
    # Set your time zone.
    time.timeZone = "Asia/Almaty";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "ru_RU.UTF-8";
      LC_IDENTIFICATION = "ru_RU.UTF-8";
      LC_MEASUREMENT = "ru_RU.UTF-8";
      LC_MONETARY = "ru_RU.UTF-8";
      LC_NAME = "ru_RU.UTF-8";
      LC_NUMERIC = "ru_RU.UTF-8";
      LC_PAPER = "ru_RU.UTF-8";
      LC_TELEPHONE = "ru_RU.UTF-8";
      LC_TIME = "ru_RU.UTF-8";
    };
  };

  module_audio = { ... }: {
    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;

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

  module_containers = { pkgs, ... }:
    {
      # virtualisation.docker = { enable = true; };
      # environment.systemPackages = with pkgs; [ lazydocker ];
    };
in configuration
