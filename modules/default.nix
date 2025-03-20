{ inputs, pkgs, lib, config, ...}:

{
  home.stateVersion = "23.11"; # FIXME

  imports = [
    # Setup home-manager modules
    inputs.nix-colors.homeManagerModules.default
    inputs.embermug.homeModules.default

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
    ./aerospace

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
    NIXOS_OZONE_WL="1";
    GOPRIVATE="github.com/huntresslabs";
    LIBVIRT_DEFAULT_URI="qemu:///system";
  };

  home.packages = (import ../packages/default.nix {
    inherit pkgs;
    inherit lib;
  }) ++ (import (../packages + "/${pkgs.system}.nix") {
    inherit pkgs;
  });

  programs.man = {
    enable = true;
    generateCaches = false;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    config = {
      global.hide_env_diff = true;
    };

    stdlib = ''
        layout_poetry() {
          POETRY_DIR="''${POETRY_DIR:-.}"

          # Verify we have a project
          PYPROJECT_TOML="''${PYPROJECT_TOML:-pyproject.toml}"
          if [[ ! -f "$PYPROJECT_TOML" ]]; then
            log_error "no pyproject.toml found. use \`poetry init\` to create \`$PYPROJECT_TOML\` first."
            exit 2
          fi

          # Lookup the active poetry environment
          VIRTUAL_ENV=$(poetry -C "$POETRY_DIR" env info --path 2>/dev/null ; true)
          if [[ -z $VIRTUAL_ENV || ! -d $VIRTUAL_ENV ]]; then
            log_status "no poetry environment exists."
            log_status "executing \`poetry install\` to create one."
            poetry -C "$POETRY_DIR" install
            VIRTUAL_ENV=$(poetry -C "$POETRY_DIR" env info --path)
          fi

          # Activate the environment. We don't use 'poetry shell' because that
          # spawns a subshell. Instead, we manually activate the environment by
          # adding the bin directory to our path, and setting VIRTUAL_ENV.
          log_status "using poetry environment: $VIRTUAL_ENV"
          PATH_add "$VIRTUAL_ENV/bin"
          export POETRY_ACTIVE=1  # or VENV_ACTIVE=1
          export VIRTUAL_ENV
        }
    '';
  };
}
