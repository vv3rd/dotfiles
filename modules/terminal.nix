{ pkgs, ... }:

let
  session = "wayland";
  # session = "xorg";
in
{
  home.packages = with pkgs; [
    ripgrep
    repgrep
    btop
    eza
    fzf
    jq
    just
    rm-improved
    fd
    diskonaut

    kubectl
    kubectx
    kubelogin
    kubelogin-oidc
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    MANROFFOPT = "-c"; # without this man with bat pager outputs escape codes
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    WORDCHARS = "*?_.[]~=&;!#$%^(){}<>";
    DIRENV_LOG_FORMAT = ""; # silences direnv logs
  };

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
    flags = [ "--disable-up-arrow" ];
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
    shellAliases =
      {
        "ghi" = "git -c diff.external=difft log -p --ext-diff";
        "gdf" = "git diff";
        "gsw" = "git switch";
        "gsl" = "git stash list";
        "gsp" = "git stash pop";
        "gsa" = "git stash --include-untracked";
        "glg" =
          "git log" # //
          + " --branches --remotes --graph --abbrev-commit --decorate"
          + " --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
        "gac" = "git add . && git commit";
        "gin" = "git status";
        "gdi" = "git diff";
        "gbr" = "git br";
        "gbl" = "git bl";
        "gswr" = "git br | fzf | xargs git switch";
        "gswl" = "git bl | fzf | xargs git switch";
        "fj" = "$EDITOR";
        "fji" = "$EDITOR $(git diff --staged --diff-filter=MR --name-only --relative)";
        "l" = "exa -a1 --group-directories-first --icons";
        "ls" = "exa --group-directories-first --icons";
        "lt" = "l --git-ignore -T -L=2";
        "o" = "bat --plain";
        "j" = "just";
      }
      // ({
        mac = {
          "clip" = "pbcopy";
          "clip-out" = "pbpaste";
        };
        xorg = {
          "clip" = "${pkgs.xclip} -i -selection c";
          "clip-out" = "${pkgs.xclip} -o -selection c";
        };
        wayland = {
          "clip" = "${pkgs.wl-clipboard}/bin/wl-copy";
          "clip-out" = "${pkgs.wl-clipboard}/bin/wl-paste";
        };
      }).${session};

    initExtra =
      # sh
      ''
        source ~/.zuser
        autoload -U edit-command-line
        zle -N edit-command-line
        bindkey "^E" edit-command-line
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
          sha256 = "sha256-H7DYDLNANFnws3pCANnMJAQIMDXCf9S+ggUOGUy1oO0=";
        };
      }
    ];
    history = {
      path = "$ZDOTDIR/.zsh_history";
      ignorePatterns = [
        "rm *"
        "EOF"
      ];
      ignoreAllDups = true;
    };
  };

  programs.git = {
    enable = true;
    aliases = {
      unstage = "restore --staged";
      search = "log --patch --grep";
      hidden = "! git ls-files -v | grep '^h' | cut -c3-";
      skipped = "! git ls-files -v | grep '^S' | cut -c3-";
      bl = "branch --format='%(refname:short)'";
      br = "branch -r --format='%(refname:lstrip=3)'";
    };
    includes = [ { path = "~/.gituser.inc"; } ];
    extraConfig = {
      init.defaultBranch = "main";
    };
    difftastic = {
      enable = true;
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
}
