# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
let
  configuration =
    {
      config,
      pkgs,
      lib,
      system,
      inputs,
      user,
      ...
    }:
    {
      imports = [
        ./hardware-configuration.nix

        module-essentials
        module-network
        module-user

        # module_desktop-Plasma
        module-desktop-Niri
        module-locale
        module-unfree
      ];

      environment.systemPackages = with pkgs; [
        #
        dig.dnsutils
        inetutils
        wget
        zip
        unzip
        transmission_4-gtk
      ];

      home-manager.extraSpecialArgs = { inherit inputs; };
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.users.${user} =
        { pkgs, ... }:
        {
          home.stateVersion = "25.05";
          programs.home-manager.enable = true;
          imports = [
            ./home.nix
          ];
        };

    };

  module-essentials =
    { ... }:
    {

      boot.loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 8;
        };
        efi.canTouchEfiVariables = true;
      };

      services.upower.enable = true;
      services.tlp = {
        enable = true;
        settings = {
          START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
          STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        };
      };

      hardware.bluetooth.enable = true; # enables support for Bluetooth

      documentation.dev.enable = true;

      programs.command-not-found.enable = false;
      programs.nix-index = {
        enable = true;
        enableZshIntegration = true;
      };
    };

  module-network =
    { pkgs, ... }:
    {
      # essentials
      networking.hostName = "zenbook"; # Define your hostname.

      # Enable networking
      networking.networkmanager = {
        enable = true;
        plugins = with pkgs; [
          networkmanager-openvpn
        ];
      };

      # https://wiki.nixos.org/wiki/WireGuard
      # services.kresd.enable = true;
      # services.resolved.enable = false;
      # environment.etc."resolv.conf" = {
      #   mode = "0644";
      #   text = "nameserver ::1";
      # };

      # vpn
      programs.openvpn3 = {
        enable = true;
      };
      services.tailscale.enable = true;

      environment.systemPackages = [
        pkgs.wireguard-tools
      ];

      # mDNS
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        hostName = "rsndev";
        publish = {
          enable = true;
          addresses = true;
          workstation = true;
          userServices = true;
        };
      };
      networking.firewall.allowedUDPPorts = [ 5353 ];

      programs.localsend = {
        enable = true;
        openFirewall = true;
      };

      # for development purposes
      networking.firewall.allowedTCPPorts = [ 8080 ];
    };

  module-user =
    { pkgs, user, ... }:
    {
      environment.sessionVariables = {
        TERMINAL = "${pkgs.alacritty}/bin/alacritty";
        # home dir cleanup
        XCOMPOSECACHE = "$HOME/.cache/compose-cache";
        GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc-2.0";
        # KUBECONFIG = "$XDG_CONFIG_HOME/kube";
        # KUBECACHEDIR = "$XDG_CACHE_HOME/kube";
        # NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
        # DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
        # CARGO_HOME = "$XDG_DATA_HOME/cargo";
      };

      xdg.terminal-exec = {
        enable = true;
        settings = {
          default = [ "Alacritty.desktop" ];
        };
      };

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.${user} = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
        shell = pkgs.zsh;
      };

      # settings ZSH as default
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

  module-desktop-Niri =
    {
      inputs,
      pkgs,
      system,
      user,
      ...
    }:
    {
      environment.sessionVariables = {
        DISPLAY = ":0";
      };

      services.getty = {
        autologinOnce = true;
        autologinUser = user;
      };

      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.niri-scratchpad.packages.${pkgs.system}.niri-scratchpad
        (pkgs.callPackage ../../apps/scratchterm { })
        pkgs.xwayland-satellite
        pkgs.brightnessctl
        pkgs.networkmanagerapplet
        pkgs.clipse
        pkgs.wl-clipboard
        # pkgs.kanata
        pkgs.keyd
        pkgs.bluetuith

        # portals
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-wlr
      ];

      xdg.portal = {
        enable = true;
        config = {
          niri = {
            default = [ "gtk" ];
            "org.freedesktop.impl.portal.ScreenCast" = "gnome";
          };
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
        ];
      };

      # TODO:
      # - Brightness status
      # - Notifications popups
      # - gotmpl alacritty theme
      # - Alacritty clipboard shortcuts
      programs.niri = {
        enable = true;
        # package = inputs.niri.packages.${system}.niri;
        useNautilus = false;
      };

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

      # services.kanata.enable = true;
      # services.kanata.keyboards = {
      #   "lofree".configFile = ./dotconfig/kanata/lofree.kbd;
      # };
    };

  module-locale =
    { ... }:
    {
      # Set your time zone.
      # time.timeZone = "Asia/Almaty";
      services.automatic-timezoned = {
        enable = true;
      };

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
        LC_TIME = "en_GB.UTF-8";
      };
    };

  module-unfree =
    { lib, pkgs, ... }:
    let
      unfreePackages = with pkgs; [
        google-chrome
        android-studio
        android-tools
      ];
      unfreePackagesNames = (map lib.getName (unfreePackages)) ++ [
        "androidsdk"
      ];
    in
    {
      environment.systemPackages = unfreePackages;
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) unfreePackagesNames;
      # nixpkgs.config.allowUnfree = true;
      nixpkgs.config.android_sdk.accept_license = true;
    };
in
configuration
