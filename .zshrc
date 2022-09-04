# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_DIR="${HOME}/.zsh"
if [ -d $ZSH_DIR ] && [ -r $ZSH_DIR ] && [ -x $ZSH_DIR ]; then
    for file in ${ZSH_DIR}/**/*.zsh; do
        [ -r $file ] && source $file
    done
fi

zimfw install >/dev/null 2>&1

# exa
if [[ $(command -v exa) ]]; then
    alias ls='exa --icons --git'
    alias lt='exa -T -L 3 -a -I "node_modules|.git|.cache" --icons'
    alias ltl='exa -T -L 3 -a -I "node_modules|.git|.cache" -l --icons'
fi

# ssh
if [[ $(command -v ssh) ]]; then
    alias ssh='source $HOME/.keychain/$HOST-sh; ssh'
fi

alias python="python3"
alias pip="pip3"
alias gc="git clone"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
