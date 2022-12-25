#!/bin/bash -eu
cd $(dirname $0)

echo "Creating dotfile links."
IGNORE_PATTERN="^\.(git|travis|vscode)"
for dotfile in .??*; do
    [[ $dotfile =~ $IGNORE_PATTERN ]] && continue
    ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done

function is_os() {
    if [ "$(uname)" == 'Darwin' ]; then
        echo 'Mac'
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        echo 'Linux'
    elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
        echo 'Cygwin'
    else
        echo "Your platform ($(uname -a)) is not supported."
        exit 1
    fi
}

echo "Upgrading apt"
if [ "$(is_os)" == "Linux" ]; then
    sudo sed -i -e 's|archive.ubuntu.com|ubuntutym.u-toyama.ac.jp|g' /etc/apt/sources.list
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt autoremove -y
    if which zsh >/dev/null 2>&1; then
        echo "installing zsh gcc build-essential"
        sudo apt install zsh gcc build-essential xdg-utils gdb -y
    fi
    if [ "$(echo $SHELL)" != "/bin/zsh" ]; then
        chsh -s /bin/zsh
    fi
fi

echo "Installing Homebrew"
which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo "Updating Homebrew"
brew doctor
brew update
brew upgrade
brew bundle
brew cleanup

echo "Installing PIP packages"
pip3 install -U -r requirements.txt

echo "Installing n, Node.js, npm and npm packages by n"
n latest
npm install -g npm typescript eslint gimonfu npm @vue/cli textlint-filter-rule-comments textlint-rule-ja-space-around-link textlint-rule-preset-ja-spacing textlint-rule-preset-ja-technical-writing textlint-rule-preset-japanese textlint-rule-preset-jtf-style textlint-rule-prh textlint-rule-spellcheck-tech-word textlint

echo "dotfiles Installation is finished."
echo "Please restart terminal."
