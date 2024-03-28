{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {

      nixpkgs = {
        # Allow proprietary software
        config.allowUnfree = true;
      };
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment = {
        systemPackages = with pkgs; [
          awscli
          bash-completion
          bat
          colordiff
          colima
          curl
          docker-client
          git
          gnupg
          jq
          yq
          lua
          kompose
          kustomize
          kubectl
          kubebuilder
          kubernetes-helm
          go
          gradle
          ripgrep
          tflint
          tree-sitter
          pyenv
          nodejs_21
          tree
          watch
          minikube
          kind
          wget
          zsh-powerlevel10k
          neovim
        ];
      } ;

      # Use a custom configuration.nix location.
      # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
      # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;
      # Tastenwiederholrate
      system.defaults.NSGlobalDomain.KeyRepeat = 2;
      # Ansprechvezögerung
      system.defaults.NSGlobalDomain.InitialKeyRepeat = 15;

      homebrew = {
          enable = true;
          onActivation.upgrade = true;
          brews = [
            "helm" "zsh-syntax-highlighting" "zsh-autosuggestions" "powerlevel10k" "terraform" "k9s" "vault"
          ];
          casks = [
            "wezterm"
            "google-chrome"
            "keka" 
            "macpass"
            "slack"
            "spotify"
            "zoom"
            "rectangle"
          ];
        };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin"; #x86_64-darwin
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."simple".pkgs;
  };
}
