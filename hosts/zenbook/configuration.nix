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
        module-user

        # module_desktop-Plasma
        module-locale
      ];
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

      documentation.dev.enable = true;

      programs.command-not-found.enable = false;
      programs.nix-index = {
        enable = true;
        enableZshIntegration = true;
      };
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

  
in
configuration
