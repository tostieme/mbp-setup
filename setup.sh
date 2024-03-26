#!/bin/bash

set -e -x

# We need sudo - adjust username
su tostieme

# Install nix
sh <(curl -L https://nixos.org/nix/install)

# Install Nix-Darwin
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Packer for nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Move configuration.nix
cp -r darwin-configuration.nix ~/.nixpkgs/

# Move configs 
# # Wezterm
cp .wezterm.lua ~/.wezterm.lua

# nvim
cp -r nvim ~/.config/
# Run Packer Sync
nvim ~/.config/nvim/lua/tostieme/packer.lua --headless -c 'so' -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# .zshrc
mv .zshrc ~/.zshrc

# Run nix
darwin-rebuild switch



