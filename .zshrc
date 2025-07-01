typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_CUSTOM=$HOME/.config/oh-my-zsh/
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
fi

export EDITOR='nvim'
export PATH="$PATH:$HOME/go/bin/:$HOME/.cargo/bin:/us:$HOME/.local/bin"

# Compilation flags
export ARCHFLAGS="-arch $(uname -m)"

# Set autosuggestion color
source ~/.config/oh-my-zsh/.zsh_highlight_styles

alias todo='nvim ~/Documents/tasks.md'
alias venv='[[ -d .venv ]] && source .venv/bin/activate || python -m venv .venv && source .venv/bin/activate'
alias vpn='~/VPN/vpn.py'
alias scratch='nvim /tmp/scratch.md'
alias hg='history | grep'

precmd() {
    print ""

}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export LS_COLORS="ow=1;34;40:di=34"
export MEDIA="/media/alice/MEDIA/media_server"

eval "$(zoxide init zsh)"
