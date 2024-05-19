{ inputs, pkgs, config, ...}:

{
  home.stateVersion = "23.11"; # FIXME

  imports = [
    # Setup home-manager modules
    inputs.nixvim.homeManagerModules.nixvim
    inputs.nix-colors.homeManagerModules.default

    # Graphical User Interface (GUI)
    ./firefox
    ./alacritty
    ./eww
    ./waybar
    ./dunst
    ./hyprland
    ./wofi
    ./rofi
    ./obs

    # Command Line Interface (CLI)
    ./neovim
    ./zsh
    ./git
    ./golang
    # ./gpg
    # ./direnv

    # System
    # ./xdg
    # ./packages
  ];

  programs.jq.enable = true;

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;

  gtk = {
    enable = true;

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    theme = {
      name = "Numix";
      package = pkgs.numix-gtk-theme;
    };
    
    iconTheme = {
      name = "Numix";
      package = pkgs.numix-icon-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  home.packages = with pkgs; [
    neofetch
    pwvucontrol
    pw-volume
  ];
}
