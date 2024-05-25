{ config, lib, inputs, username, ...}:

{
  imports = [
    ../../modules/default.nix
  ];
  config.modules = {
    # Graphical User Interface (GUI)
    firefox.enable = true;
    alacritty.enable = true;
    eww.enable = false;
    waybar.enable = true;
    dunst.enable = false;
    swaync.enable = true;
    wofi.enable = false;
    rofi.enable = true;
    obs.enable = true;

    hyprland = {
      enable = true;
      swap_escape = false; # We use a nice keyboard :)
      
      monitors = [
        "desc:Dell Inc. DELL U2723QE 55L01P3,preferred,0x0,1"
        "desc:Dell Inc. DELL U2718Q 4K8X7974188L,preferred,3840x0,1"
        "desc:Dell Inc. DELL U2723QE HXJ01P3,preferred,7680x0,1"
      ];
    };

    # Command Line Interface (CLI)
    neovim.enable = true;
    zsh.enable = true;
    git.enable = true;
    golang.enable = true;
    # gpg.enable = true;
    # direnv.enable = true;

    # System
    # xdg.enable = true;
    # packages.enable = true;
  };
}
