# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
let
  configuration = { config, pkgs, lib, ... }: {
    imports =
      [
        /etc/nixos/hardware-configuration.nix
        <home-manager/nixos>

        module_essentials
        module_user
        module_audio
        module_desktop-Plasma
        # module_desktop-Hyprland
        module_browser-Firefox
        module_locale-Almaty
        module_containerization
      ];

    programs.openvpn3.enable = true;

    documentation.dev.enable = true;
    documentation.man = {
      man-db.enable = true;
      mandoc.enable = true;
    };

    environment.systemPackages = [
      pkgs.fusuma
    ];

    home-manager.users.odmin = { pkgs, ... }: {
      programs.home-manager.enable = true;

      home.sessionVariables = {
        EDITOR = "hx";
        MANROFFOPT = "-c"; # without this man with bat pager outputs escape codes
        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
        WORDCHARS = "*?_.[]~=&;!#$%^(){}<>";
        DIRENV_LOG_FORMAT = ""; # silences direnv logs
      };

      nixpkgs = {
        config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          "discord"
          "vscode"
        ];
      };

      home.packages = [
        pkgs.brave
        pkgs.btop
        pkgs.discord
        pkgs.eza
        pkgs.fzf
        pkgs.jq
        pkgs.just
        pkgs.mpc-qt
        pkgs.neofetch
        pkgs.nil
        pkgs.nixpkgs-fmt
        pkgs.ripgrep
        pkgs.signal-desktop
        pkgs.telegram-desktop
        pkgs.transmission-qt
        pkgs.vscode
        pkgs.xclip
        pkgs.yt-dlp
        pkgs.rm-improved
        pkgs.fd

        # required to create video screen capture
        pkgs.ffmpeg_6-full
        pkgs.slop
      ];

      programs.nix-index = {
        enable = true;
      };

      programs.bat = {
        enable = true;
      };

      programs.mpv = {
        enable = true;
        consfig = {
          save-position-on-quit = true;
          autofit-larger="100%x100%";
          sub-scale=0.4;
          sub-scale-by-window="no";
        };
      };

      programs.atuin = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          update_check = false;
          style = "compact";
        };
        flags = [
          "--disable-up-arrow"
        ];
      };

      programs.alacritty = {
        enable = true;
        settings = {
          window.opacity = 0.9;
          font.size = 8;
          font.normal.family = "NotoMono Nerd Font";
        };
        settings.key_bindings = [
          { key = "N"; mods = "Control|Shift"; action = "SpawnNewInstance"; }
        ];
      };

      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
        config = {
          load_dotenv = true;
        };
      };

      programs.git = {
        enable = true;
        userEmail = "lyudskoy@gmail.com";
        userName = "alek";
        aliases = {
          search = "log --patch --grep";
          hidden = "! git ls-files -v | grep '^h' | cut -c3-";
          skipped = "! git ls-files -v | grep '^S' | cut -c3-";
          gr = "log --graph --abbrev-commit --all --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
          grd = "log --graph --abbrev-commit --all --decorate --date=format:'%D %R' --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)%ad%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
          graph = "gr";
          bl = "branch --format='%(refname:short)'";
          br = "branch -r --format='%(refname:lstrip=3)'";
        };
        extraConfig = {
          init.defaultBranch = "main";
        };
        includes = [
          { condition = "gitdir:~/Work/rsn/"; path = "~/Work/rsn/.gitconfig"; }
        ];
        delta = {
          enable = true;
        };
      };

      programs.zsh = {
        enable = true;
        enableAutosuggestions = true;
        dotDir = ".config/zsh";
        shellAliases = {
          "gsw" = "git switch";
          "gsl" = "git stash list";
          "gsp" = "git stash pop";
          "gsa" = "git stash --include-untracked";
          "glg" = "git graph";
          "gac" = "git add . && git commit";
          "gin" = "git status";
          "gdi" = "git diff";
          "gbr" = "git br";
          "gbl" = "git bl";
          "gswr" = "git br | fzf | xargs git switch";
          "gswl" = "git bl | fzf | xargs git switch";
          "fj" = "$EDITOR";
          "l" = "exa -a1 --group-directories-first --icons";
          "ls" = "exa --group-directories-first --icons";
          "lg" = "l --git-ignore -T -L=2";
          "o" = "bat --plain";
          "j" = "just";
          "clipSet" = "xclip -i -selection c";
          "clipGet" = "xclip -o -selection c";
        };
        initExtra = ''
          bindkey "^[[1;5C" forward-word
          bindkey "^[[1;5D" backward-word
          [[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"
        '';
        plugins = [
          {
            name = "powerlevel10k";
            file = "powerlevel10k.zsh-theme";
            src = pkgs.fetchFromGitHub {
              owner = "romkatv";
              repo = "powerlevel10k";
              rev = "master";
              sha256 = "sha256-GHHoV9RfokusOKUjQ7yaxwENdM82l1qHiebs1AboMfY=";
            };
          }
        ];
        history = {
          path = "$ZDOTDIR/.zsh_history";
          ignorePatterns = [ "rm *" "EOF" ];
        };
      };

      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.lf = {
        enable = true;
      };

      programs.zellij = {
        enable = true;
        settings = {
          pane_frames = false;
          default_layout = "compact";
        };
      };

      home.stateVersion = "23.05";
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?
  };

  module_essentials = { ... }: {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    networking.hostName = "nixos"; # Define your hostname.
    networking.networkmanager.enable = true; # Enable networking
    services.printing.enable = true; # Enable CUPS to print documents.
    hardware.bluetooth.enable = true; # enables support for Bluetooth

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };

  module_user = { pkgs, ... }: {
    environment.sessionVariables = {
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
      description = "odmin";
      extraGroups = [ "networkmanager" "wheel" ];
    };

    # settings ZSH as default
    users.users.odmin.shell = pkgs.zsh;
    environment.shells = [ pkgs.zsh ]; # Many programs look at /etc/shells to determine if a user is a "normal" user and not a "system" user.
    programs.zsh.enable = true;
  };

  module_desktop-Plasma = { pkgs, ... }: {
    fonts.packages = [
      (pkgs.nerdfonts.override { fonts = [ "Noto" "ComicShanns" ]; })
    ];

    services.xserver = {
      # Enable the X11 windowing system.
      enable = true;

      # Enable the KDE Plasma Desktop Environment.
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;

      # Configure keymap in X11
      layout = "us";
      xkbVariant = "";

      # Disable drag release delay
      libinput.touchpad.tappingDragLock = false;
    };
  };

  module_browser-Firefox = { ... }: {
    programs.firefox.enable = true;
    environment.sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
  };

  module_locale-Almaty = { ... }: {
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

  module_containerization = inputs: {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # doesn't work; cannot access dev/* because of permissions TODO: find a way to give it permission
  # home_module_fusuma = inputs: {
  #   services.fusuma = {
  #     enable = true;
  #     settings = {
  #       threshold = { swipe = 0.1; };
  #       interval = { swipe = 0.7; };
  #       swipe = {
  #         "4" = {
  #           up = {
  #             command = "qdbus org.kde.kglobalaccel /component/kmix invokeShortcut 'increase_volume'";
  #           };
  #           down = {
  #             command = "qdbus org.kde.kglobalaccel /component/kmix invokeShortcut 'decrease_volume'";
  #           };
  #         };
  #       };
  #     };
  #   };
  # };
in
configuration
