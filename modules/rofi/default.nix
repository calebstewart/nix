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
    home.file.".config/rofi/colors.rasi".text = ''
    * {
      background:     #282828FF;
      background-alt: #353535FF;
      foreground:     #EBDBB2FF;
      selected:       #83A598FF;
      active:         #B8BB26FF;
      urgent:         #FB4934FF;
    }
    '';

    home.file.".config/rofi/launcher.rasi".source = ./launcher.rasi;
  };
}
