{pkgs, lib, config, ...}:
let
  cfg = config.modules.dunst;
in {
  options.modules.dunst = { enable = lib.mkEnableOption "dunst"; };

  config = lib.mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          origin = "top-right";
          offset = "120x24";
          separator_height = 4;
          padding = 12;
          horizontal_padding = 12;
          text_icon_padding = 12;
          frame_width = 4;
          separator_color = "frame";
          idle_threshold = 120;
          font = "JetBrainsMono NerdFont 12";
          line_height = 0;
          format = "<b>%s</b>\n%b";
          alignment = "center";
          icon_position = "left";
          startup_notification = "false";
          corner_radius = 12;
          frame_color = "#44465c";
          background = "#303241";
          foreground = "#d9e0ee";
          timeout = 2;
        };
      };
    };
  };
}
