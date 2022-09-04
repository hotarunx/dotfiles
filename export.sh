#!/bin/bash -eu
cd $(dirname $0)

echo "Export brew bundle"
brew bundle dump --force
