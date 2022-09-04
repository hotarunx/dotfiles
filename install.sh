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
    if which zsh >/dev/null 2>&1; then
        echo "installing zsh gcc build-essential"
        sudo apt install zsh gcc build-essential -y
    fi
    chsh -s /bin/zsh
fi

echo "Installing Homebrew"
which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo "Updating Homebrew"
brew doctor
brew update
brew upgrade
brew bundle
brew cleanup

echo "Installing zimfw"
test -e $HOME/.zim >/dev/null 2>&1 || curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

echo "Installing PIP packages"
pip3 install -U -r requirements.txt

echo "Installing n, Node.js, npm and npm packages by n"
# make cache folder (if missing) and take ownership
sudo mkdir -p /usr/local/n
sudo chown -R $(whoami) /usr/local/n
# make sure the required folders exist (safe to execute even if they already exist)
sudo mkdir -p /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
# take ownership of Node.js install destination folders
sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
n latest

npm install -g npm typescript eslint gimonfu npm textlint-filter-rule-comments textlint-rule-ja-space-around-link textlint-rule-preset-ja-spacing textlint-rule-preset-ja-technical-writing textlint-rule-preset-japanese textlint-rule-preset-jtf-style textlint-rule-prh textlint-rule-spellcheck-tech-word textlint

echo "dotfiles Installation is finished."
echo "Please restart terminal."
