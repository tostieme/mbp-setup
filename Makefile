# Install nix
install-nix:
	sudo sh <(curl -L https://nixos.org/nix/install)

# Install Nix-Darwin
install-nix-darwin:
	sudo nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
	sudo ./result/bin/darwin-installer

# Install Homebrew
install-homebrew:
	sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Packer for nvim
install-packer:
	git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

move-config:
	cp -r darwin-configuration.nix ~/.nixpkgs/
	cp .wezterm.lua ~/.wezterm.lua
	sudo rm -fr ~/.zshrc
	cp .zshrc ~/.zshrc
	git clone --depth 1 git@github.com:tostieme/nvim-conf.git ~/.config/nvim

# Run nix
darin-rebuild:
	sudo darwin-rebuild switch

