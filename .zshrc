# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.

# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
unsetopt correct

# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# nvm
export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# nvm


# pnpm
export PNPM_HOME="/home/odmin/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm

# golang
export PATH="$PATH:$HOME/go/bin"
# golang

# opam
[[ ! -r /home/odmin/.opam/opam-init/init.zsh ]] || source /home/odmin/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
# opam

# deno
export DENO_INSTALL="/home/odmin/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
# deno

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export EDITOR="helix"

eval $(thefuck --alias)


alias fj=$EDITOR
alias clipset="xclip -selection c"
alias clipget="xclip -selection c -o"
alias dotfile="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# git aliases
alias gitlazy='git add . && git commit -m "$(date +"%d.%m %k:%M")" && git push'
alias gsw='git switch'
alias gsl='git stash list'
alias gsp='git stash pop'
alias gsa='git stash --include-untracked'
alias glg='git graph'
alias gac='git add . && git commit'
alias gin='git status'
alias gswg="git branch -a --format='%(refname:short)' | fzf | xargs git switch"

# Miscellaneous apps
alias lzd='lazydocker'
alias lzg="lazygit"
alias here='dolphin --new-window . &!'


# Opens lf file manager and cd-s to chosen directory on close
lfcd () {
    tmp="$(mktemp)"
    # `command` is needed in case `lfcd` is aliased to `lf`
    command lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

