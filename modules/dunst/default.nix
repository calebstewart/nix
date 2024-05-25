{pkgs, lib, config, ...}:
let
  cfg = config.modules.dunst;
in {
  options.modules.dunst = { enable = lib.mkEnableOption "dunst"; };

  config = lib.mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = with config.colorScheme.palette; {
          origin = "top-right";
          offset = "24x24";
          separator_height = 2;
          padding = 12;
          horizontal_padding = 12;
          text_icon_padding = 12;
          frame_width = 1;
          separator_color = "#${base04}ee";
          idle_threshold = 120;
          font = "JetBrainsMono NerdFont 12";
          line_height = 0;
          format = "<b>%s</b>\n%b";
          alignment = "center";
          icon_position = "left";
          startup_notification = "false";
          corner_radius = 15;
          frame_color = "#${base0D}ee";
          background = "#${base00}ee";
          foreground = "#${base05}ee";
          timeout = 4;
        };
      };
    };
  };
}
