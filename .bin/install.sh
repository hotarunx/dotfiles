#!/usr/bin/env bash

# MIT License

# Copyright (c) 2016 Yuta Katayama

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# https://github.com/yutkat/dotfiles/blob/main/LICENSE
set -ue

helpmsg() {
    command echo "Usage: $0 [--help | -h]" 0>&2
    command echo ""
}

link_to_homedir() {
    command echo "backup old dotfiles..."
    if [ ! -d "$HOME/.dotbackup" ]; then
        command echo "$HOME/.dotbackup not found. Auto Make it"
        command mkdir "$HOME/.dotbackup"
    fi

    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
    local dotdir=$(dirname ${script_dir})
    if [[ "$HOME" != "$dotdir" ]]; then
        for f in $dotdir/.??*; do
            [[ $(basename $f) == ".git" ]] && continue
            if [[ -L "$HOME/$(basename $f)" ]]; then
                command rm -f "$HOME/$(basename $f)"
            fi
            if [[ -e "$HOME/$(basename $f)" ]]; then
                command mv "$HOME/$(basename $f)" "$HOME/.dotbackup"
            fi
            command ln -snf $f $HOME
        done
    else
        command echo "same install src dest"
    fi
}

while [ $# -gt 0 ]; do
    case ${1} in
    --debug | -d)
        set -uex
        ;;
    --help | -h)
        helpmsg
        exit 1
        ;;
    *) ;;

    esac
    shift
done

link_to_homedir
git config --global include.path "~/.gitconfig_shared"
command echo -e "\e[1;36m Install completed!!!! \e[m"
# https://github.com/yutkat/dotfiles/blob/main/LICENSE

# dotfilesの管理を楽にする話 https://zenn.dev/tkomatsu/articles/d7d089acd29cfa4d57b4
echo "installing Homebrew ..."
which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# dotfilesの管理を楽にする話 https://zenn.dev/tkomatsu/articles/d7d089acd29cfa4d57b4

if [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>/home/hotaru/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    sudo apt-get install build-essential -y
    brew install gcc
    sudo apt install zsh
    chsh -s /bin/zsh
fi

# dotfilesの管理を楽にする話 https://zenn.dev/tkomatsu/articles/d7d089acd29cfa4d57b4
echo "run brew doctor ..."
which brew >/dev/null 2>&1 && brew doctor
echo "run brew update ..."
which brew >/dev/null 2>&1 && brew update
echo "ok. run brew upgrade ..."
brew upgrade
brew bundle --file ~/.Brewfile
brew cleanup
# dotfilesの管理を楽にする話 https://zenn.dev/tkomatsu/articles/d7d089acd29cfa4d57b4

which zimfw >/dev/null 2>&1 && curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
