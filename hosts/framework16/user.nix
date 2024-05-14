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
    dunst.enable = true;
    hyprland.enable = true;
    wofi.enable = false;
    rofi.enable = true;
    obs.enable = true;

    # Command Line Interface (CLI)
    neovim.enable = true;
    zsh.enable = true;
    git.enable = true;
    # gpg.enable = true;
    # direnv.enable = true;

    # System
    # xdg.enable = true;
    # packages.enable = true;
  };
}
