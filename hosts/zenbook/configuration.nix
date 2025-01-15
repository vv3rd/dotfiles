# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
let
  user = "odmin";

  configuration =
    {
      config,
      pkgs,
      lib,
      system,
      inputs,
      ...
    }:
    {
      imports = [
        ./hardware-configuration.nix

        module_essentials
        module_user
        module_audio
        # module_desktop-Plasma
        module_desktop-Niri
        module_keyboard
        module_browser-Firefox
        module_locale
        module_containers
      ];

      programs.openvpn3.enable = true;
      services.tailscale = {
        enable = true;
      };

      documentation.dev.enable = true;

      environment.systemPackages = with pkgs; [
        #
        nh
        dig.dnsutils
        wget
      ];

      fonts.packages = [
        (pkgs.nerdfonts.override {
          fonts = [
            "Noto"
            "GeistMono"
            "Hack"
            "Gohu"
          ];
        })
      ];

      home-manager.extraSpecialArgs = {
        inherit system inputs;
      };

      home-manager.useGlobalPkgs = true;

      home-manager.users.${user} =
        { pkgs, ... }:
        {
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

  module_essentials =
    { ... }:
    {
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      networking.hostName = "zenbook"; # Define your hostname.
      networking.networkmanager.enable = true; # Enable networking
      services.printing.enable = true; # Enable CUPS to print documents.
      hardware.bluetooth.enable = true; # enables support for Bluetooth

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

  module_keyboard = inputs: {
    services.xremap.watch = true;
    services.xremap.config.modmap = [
      {
        name = "Global";
        remap = {
          "CapsLock" = {
            held = "Ctrl_R";
            alone = "Esc";
            alone_timeout = 200;
          };
        };
      }
    ];
  };

  module_user =
    { pkgs, ... }:
    {
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
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
      };

      # settings ZSH as default
      users.users.odmin.shell = pkgs.zsh;
      environment.shells = [ pkgs.zsh ];
      # Many programs look at /etc/shells to determine if a user is a "normal" user and not a "system" user.
      programs.zsh.enable = true;
    };

  # module_desktop-Plasma =
  #   { pkgs, ... }:
  #   {

  #     # Disable drag release delay
  #     services.libinput.touchpad.tappingDragLock = false;

  #     services.displayManager.sddm.enable = true;
  #     services.displayManager.sddm.wayland.enable = true;
  #     services.desktopManager.plasma6.enable = true;
  #   };

  module_desktop-Niri =
    {
      inputs,
      pkgs,
      system,
      ...
    }:
    {
      services.displayManager.ly.enable = true;
      home-manager.users.${user} = {
        programs.rofi = {
          enable = true;
          package = pkgs.rofi-wayland;
          # terminal = "${pkgs.alacritty}/bin/alacritty"; # rofi-sensible-terminal will be used
          plugins = [
            pkgs.rofi-emoji-wayland
            pkgs.rofi-calc
          ];
        };
        home.packages = [
          pkgs.rofi-bluetooth
        ];
      };
      programs.xwayland.enable = true;
      # TODO:
      # - Menus: wifi, vpn, bluetooth
      # - Feedback: volume/brightness change
      # - Wallpapers
      # - Apps: viewers for images,pdfs
      # - Notifications, status popups
      # - Battery health, profiles switching applet
      # - NetworkManager persistance (bug)
      # - Rofi managed via home-manager
      # - Clipboard history manager (cliphist)
      # - Alacritty clipboard shortcuts
      # - File manager icons
      programs.niri = {
        enable = true;
        package = inputs.niri.packages.${system}.niri;
      };
    };

  module_browser-Firefox =
    { ... }:
    {
      programs.firefox.enable = true;
      environment.sessionVariables = {
        MOZ_USE_XINPUT2 = "1";
      };
    };

  module_locale =
    { ... }:
    {
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

  module_audio =
    { ... }:
    {
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

  module_containers =
    { pkgs, ... }:
    {

      virtualisation.containers.enable = true;
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };

      environment.systemPackages = with pkgs; [
        lazydocker
        docker-compose
      ];
    };
in
configuration
