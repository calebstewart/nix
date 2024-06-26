{...}: {
  imports = [../../modules/default.nix];

  config.modules = {
    neovim.enable = true;
    zsh.enable = true;
    git.enable = true;
    zoxide.enable = true;
    bat.enable = true;
    eza.enable = true;
  };
}
