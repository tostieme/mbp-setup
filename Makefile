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
	cp -r nvim ~/.config/
	sudo rm -fr ~/.zshrc
	cp .zshrc ~/.zshrc

# Run nix
darin-rebuild:
	sudo darwin-rebuild switch

# Run Packer Sync
packer-sync:
	nvim ~/.config/nvim/lua/tostieme/packer.lua --headless -c 'so' -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

