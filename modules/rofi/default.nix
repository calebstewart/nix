{pkgs, lib, config, ...}:
let
  cfg = config.modules.rofi;
in {
  options.modules.rofi = { enable = lib.mkEnableOption "rofi"; };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi-wayland
    ];

    # Setup rofi colors
    # TODO: make these use the current colorscheme
    home.file.".config/rofi/colors.rasi".text = with config.colorScheme.palette; ''
    * {
      background: #${base00};
      background-alt: #${base01};
      foreground: #${base05};
      selected: #${base06};
      active: #${base03};
      urgent: #${base08};
    }
    '';

    home.file.".config/rofi/launcher.rasi".source = ./launcher.rasi;
  };
}
