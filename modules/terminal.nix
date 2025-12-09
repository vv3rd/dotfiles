{
  pkgs,
  lib,
  config,
  ...
}:

let
  session = if pkgs.stdenv.hostPlatform.system == "aarch64-darwin" then "mac" else "wayland";
  zshShellAliases = {
    "gac" = "git add . && git commit";
    "fj" = "$EDITOR";
    "fji" = "$EDITOR $(git diff --staged --diff-filter=MR --name-only --relative)";
  };
  shellAliases = {
    "ghi" = "git -c diff.external=difft log -p --ext-diff";
    "gd" = "git diff";
    "gsw" = "git switch";
    "gsl" = "git stash list";
    "gsp" = "git stash pop";
    "gsa" = "git stash --include-untracked";
    "glgb" =
      "git log --graph --pretty=format:'%C(bold blue)%h%C(reset)%C(auto)%d%C(reset)%C(dim white) - %ae [%ah]%C(reset) %n%C(white)%s %C(reset)%n'";
    "glg" = "glgb --all";
    "gin" = "git status";
    "gdi" = "git diff";
    "gbr" = "git br";
    "gbl" = "git bl";
    "gbrf" = "git br | fzf";
    "gblf" = "git bl | fzf";
    "gswr" = "git br | fzf | xargs git switch";
    "gswl" = "git bl | fzf | xargs git switch";
    "gcb" = "git branch --show-current";
    "l" = "exa -a1 --group-directories-first --icons";
    "lt2" = "l --git-ignore -T -L=2";
    "lt3" = "l --git-ignore -T -L=3";
    "lt4" = "l --git-ignore -T -L=4";
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

  envVars = {
    EDITOR = "hx";
    MANROFFOPT = "-c"; # without this man with bat pager outputs escape codes
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    WORDCHARS = "*?[]~=&;!#$%^(){}<>";
    DIRENV_LOG_FORMAT = ""; # silences direnv logs
  };
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
    fd

    kubectl
    kubectx
    kubelogin
    kubelogin-oidc
  ];

  home.sessionVariables = envVars;

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

  programs.carapace = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_metrics"
        "$git_status"
        "$fill "
        "$jobs"
        "$status"
        "$kubernetes"
        "$nix_shell"
        "$time"
        "$line_break"
        "$character"
      ];
      fill = {
        symbol = "·";
      };
      time = {
        disabled = false;
        format = "[$time]($style) ";
      };
      nix_shell = {
        format = "[$symbol $state]($style)";
        impure_msg = "";
        symbol = "󱄅";
      };
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = shellAliases // zshShellAliases;
    autosuggestion.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    initContent =
      # sh
      ''
        source ~/.zuser
        autoload -U edit-command-line
        zle -N edit-command-line
        bindkey "^E" edit-command-line
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
      '';
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
    includes = [ { path = "~/.gituser.inc"; } ];
    settings = {
      init.defaultBranch = "main";
      alias = {
        unstage = "restore --staged";
        search = "log --patch --grep";
        hidden = "! git ls-files -v | grep '^h' | cut -c3-";
        skipped = "! git ls-files -v | grep '^S' | cut -c3-";
        bl = "branch --format='%(refname:short)'";
        br = "branch -r --format='%(refname:lstrip=3)'";
      };
    };
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };
}
