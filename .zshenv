# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# WSL2のUbuntuでkeychain経由でssh-agentを使う
keychain -q --nogui $HOME/.ssh/id_rsa
source $HOME/.keychain/$HOST-sh
