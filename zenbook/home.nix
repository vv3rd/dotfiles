{ pkgs, lib, ... }: {
  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "hx";
    MANROFFOPT = "-c"; # without this man with bat pager outputs escape codes
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    WORDCHARS = "*?_.[]~=&;!#$%^(){}<>";
    DIRENV_LOG_FORMAT = ""; # silences direnv logs
  };

  nixpkgs = {
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "discord" "vscode" ];
  };

  home.packages = with pkgs; [
    brave
    btop
    discord
    eza
    fzf
    jq
    just
    mpc-qt
    neofetch
    nil
    nixfmt
    ripgrep
    signal-desktop
    telegram-desktop
    transmission-qt
    vscode
    xclip
    yt-dlp
    rm-improved
    fd

    # required to create video screen capture
    ffmpeg_6-full
    slop
  ];

  programs.nix-index = { enable = true; };

  programs.bat = { enable = true; };

  programs.mpv = {
    enable = true;
    config = {
      save-position-on-quit = true;
      autofit-larger = "100%x100%";
      sub-scale = 0.4;
      sub-scale-by-window = "no";
      audio-file-auto = "fuzzy";
    };
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      update_check = false;
      style = "compact";
    };
    flags = [ "--disable-up-arrow" ];
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.9;
      font.size = 8;
      font.normal.family = "NotoMono Nerd Font";
    };
    settings.keyboard.bindings = [{
      key = "N";
      mods = "Control|Shift";
      action = "SpawnNewInstance";
    }];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = { load_dotenv = true; };
  };

  programs.git = {
    enable = true;
    userEmail = secret.email;
    userName = secret.name;
    aliases = {
      search = "log --patch --grep";
      hidden = "! git ls-files -v | grep '^h' | cut -c3-";
      skipped = "! git ls-files -v | grep '^S' | cut -c3-";
      gr =
        "log --graph --abbrev-commit --all --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
      grd =
        "log --graph --abbrev-commit --all --decorate --date=format:'%D %R' --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)%ad%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
      graph = "gr";
      bl = "branch --format='%(refname:short)'";
      br = "branch -r --format='%(refname:lstrip=3)'";
    };
    extraConfig = { init.defaultBranch = "main"; };
    includes = [{
      condition = "gitdir:${secret.workDir}";
      path = "${secret.workDir}/.gitconfig";
    }];
    delta = { enable = true; };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
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
      "lt" = "l --git-ignore -T -L=2";
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
    plugins = [{
      name = "powerlevel10k";
      file = "powerlevel10k.zsh-theme";
      src = pkgs.fetchFromGitHub {
        owner = "romkatv";
        repo = "powerlevel10k";
        rev = "master";
        sha256 = "sha256-GHHoV9RfokusOKUjQ7yaxwENdM82l1qHiebs1AboMfY=";
      };
    }];
    history = {
      path = "$ZDOTDIR/.zsh_history";
      ignorePatterns = [ "rm *" "EOF" ];
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = false;
      default_layout = "compact";
    };
  };

  home.stateVersion = "23.05";
}
