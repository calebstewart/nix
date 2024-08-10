{ user, pkgs, ...}:
let
in
{
  imports = [
    ../../modules/default.nix
  ];

  config.modules = {
    # Graphical User Interface (GUI)
    alacritty.enable = true;
    pipewire.enable = true;
    neovim.enable = true;
    zsh.enable = true;
    zoxide.enable = true;
    bat.enable = true;
    eza.enable = true;
    # gpg.enable = true;
    # direnv.enable = true;

    # System
    # xdg.enable = true;
    # packages.enable = true;
  };
}
