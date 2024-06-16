{user, ...}: {
  imports = [
    ../../modules/default.nix
  ];

  config.modules = {
    # Graphical User Interface (GUI)
    firefox.enable = false;

    # Command Line Interface (CLI)
    neovim.enable = true;
    zsh.enable = true;
    git.enable = true;
    golang.enable = true;
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
