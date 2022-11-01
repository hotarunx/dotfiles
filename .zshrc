# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r '${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh' ]]; then
  source '${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh'
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

alias python="python3"
alias pip="pip3"
alias gc="git clone"

alias gc="git clone"
alias ps1="powershell.exe"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

autoload -Uz compinit
compinit
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# コマンド履歴
HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt share_history

setopt auto_pushd
setopt correct
setopt list_packed

# fzfで捗る自作コマンド一覧(zsh) - ハイパーマッスルエンジニア
# https://www.rasukarusan.com/entry/2018/08/14/083000
# fzf-cdr
alias cdd='fzf-cdr'
function fzf-cdr() {
  target_dir=$(cdr -l | sed 's/^[^ ][^ ]*  *//' | fzf)
  target_dir=$(echo ${target_dir/\~/$HOME})
  if [ -n "$target_dir" ]; then
    cd $target_dir
  fi
  zle redisplay
}
zle -N fzf-cdr
bindkey '^t' fzf-cdr

# シェルのコマンド履歴をインクリメンタルサーチで検索して素早く再利用する方法
# https://mogulla3.tech/articles/2021-09-06-search-command-history-with-incremental-search
alias his='select-history'
function select-history() {
  BUFFER=$(history -n -r 1 | fzf --exact --reverse --query="$LBUFFER" --prompt="History > ")
  CURSOR=${#BUFFER}
  zle redisplay
}
zle -N select-history
bindkey '^r' select-history
