{ inputs, pkgs, config, ...}:

{
  home.stateVersion = "23.11"; # FIXME

  imports = [
    # Setup home-manager modules
    inputs.nixvim.homeManagerModules.nixvim
    inputs.nix-colors.homeManagerModules.default
    inputs.hyprland.homeManagerModules.default

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

  home.pointerCursor = {
    gtk.enable = true;

    name = "Numix-Cursor";
    package = pkgs.numix-cursor-theme;
  };

  home.sessionVariables = {
    GOPRIVATE="github.com/huntresslabs";
  };

  home.packages = with pkgs; [
    neofetch
    pwvucontrol
    pw-volume
    signal-desktop
    slack
    vesktop
    zoom-us
    remmina
    spotify
    ffmpeg
    audacity
    gnumake
    gcc
    zip
    unzip
    file
  ];


  # Override the pwvucontrol desktop file to give a better name
  # and provide an icon.
  xdg.desktopEntries = {
    "com.saivert.pwvucontrol" = {
      name = "PipeWire Control";
      genericName = "Sound Settings";
      exec = "pwvucontrol %U";
      terminal = false;
      categories = ["AudioVideo" "Audio"];
      icon = ./.. + "/icons/equalizer.png";
    };
  };
}
