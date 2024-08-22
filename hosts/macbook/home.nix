{
  pkgs,
  config,
  ...
}: let
  onMac = true;
in {
  home.username = "alexey";
  home.homeDirectory = "/Users/alexey";

  home.stateVersion = "23.11";

  imports = [../../modules/helix.nix];

  xdg = {
    enable = true;
  };

  home.packages = [
    pkgs.btop
    pkgs.eza
    pkgs.fzf
    pkgs.jq
    pkgs.just
    pkgs.ripgrep
    pkgs.nil
    pkgs.nixpkgs-fmt
    pkgs.xclip
    pkgs.rm-improved
    pkgs.fd
    pkgs.ffmpeg-full
    pkgs.nodejs
    pkgs.nodejs.pkgs.pnpm
  ];

  home.sessionVariables = {
    FLAKE = "${config.home.homeDirectory}/Machine";
    EDITOR = "hx";
    MANROFFOPT = "-c"; # without this man with bat pager outputs escape codes
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    WORDCHARS = "*?_.[]~=&;!#$%^(){}<>";
    DIRENV_LOG_FORMAT = ""; # silences direnv logs
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.nix-index = {
  #     enable = true;
  # };

  programs.bat = {
    enable = true;
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      update_check = false;
      style = "compact";
    };
    flags = ["--disable-up-arrow"];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      load_dotenv = true;
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    shellAliases = {
      "gbl" = "git branch --format='%(refname:short)'";
      "gbr" = "git branch -r --format='%(refname:lstrip=3)'";
      "gsw" = "git switch";
      "gsl" = "git stash list";
      "gsp" = "git stash pop";
      "gsa" = "git stash --include-untracked";
      "glg" = "git log --graph --abbrev-commit --all --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
      "gac" = "git add . && git commit";
      "gin" = "git status";
      "gswr" = "gbr | fzf | xargs git switch";
      "gswl" = "gbl | fzf | xargs git switch";
      "fj" = "$EDITOR";
      "l" = "exa -a1 --group-directories-first --icons";
      "ls" = "exa --group-directories-first --icons";
      "lg" = "l --git-ignore -T -L=2";
      "o" = "bat --plain";
      "j" = "just";
      "clipSet" =
        if onMac
        then "pbcopy"
        else "xclip -i -selection c";
      "clipGet" =
        if onMac
        then "pbpaste"
        else "xclip -o -selection c";
    };
    initExtra = ''
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      [[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"

      # on mac with brew
      [[ ! -f /opt/homebrew/bin/brew ]] || eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
    plugins = [
      {
        name = "powerlevel10k";
        file = "powerlevel10k.zsh-theme";
        src = pkgs.fetchFromGitHub {
          owner = "romkatv";
          repo = "powerlevel10k";
          rev = "master";
          sha256 = "sha256-QX31mPZLhsW2HTUNULXjjzDOlXBGj7EKXex2dpGioHA=";
        };
      }
    ];
    history = {
      path = "$ZDOTDIR/.zsh_history";
      ignorePatterns = [
        "rm *"
        "EOF"
      ];
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = true;
      default_layout = "compact";
    };
  };
}
