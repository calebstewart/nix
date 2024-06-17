{ inputs, pkgs, config, ...}:

{
  home.stateVersion = "23.11"; # FIXME

  imports = [
    # Setup home-manager modules
    inputs.nix-colors.homeManagerModules.default

    # Graphical User Interface (GUI)
    ./firefox
    ./alacritty
    ./eww
    ./waybar
    ./dunst
    ./swaync
    ./hyprland
    ./wofi
    ./rofi
    ./obs
    ./pipewire
    ./sketchybar

    # Command Line Interface (CLI)
    ./neovim
    ./zsh
    ./git
    ./golang
    ./zoxide
    ./bat
    ./eza
    # ./gpg
    # ./direnv

    # System
    # ./xdg
    # ./packages
  ];

  programs.jq.enable = true;

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;

  home.sessionVariables = {
    GOPRIVATE="github.com/huntresslabs";
    LIBVIRT_DEFAULT_URI="qemu:///system";
  };

  home.packages = (import ../packages/default.nix {
    inherit pkgs;
  }) ++ (import (../packages + "/${pkgs.system}.nix") {
    inherit pkgs;
  });
}
