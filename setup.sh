#!/bin/bash

set -e -x
stty -tostop

# Install nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Install Homebrew
curl -fsSL -o install.sh https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
chmod +x install.sh
./install.sh
rm -fr install.sh
eval "$(/usr/local/bin/brew shellenv)"

# Apply flake.nix
sudo rm -fr /etc/bashrc
sudo rm -fr /etc/zshrc
nix run nix-darwin -- switch --flake .#simple

# Install Packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Get all App configs
cp .wezterm.lua ~/.wezterm.lua
cp .p10k.zsh ~/.p10k.zsh
sudo rm -fr ~/.zshrc
cp .zshrc ~/.zshrc
git clone --depth 1 git@github.com:tostieme/nvim-conf.git ~/.config/nvim

