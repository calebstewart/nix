{inputs, pkgs, lib, config, ...}:
let
  cfg = config.modules.waybar;
in {
  options.modules.waybar = { enable = lib.mkEnableOption "waybar"; };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      waybar
    ];

    programs.waybar = {
      enable = true;

      settings = [{
        layer = "top";
        margin-left = 0;
        margin-right = 0;
        spacing = 0;
        start_hidden = true;

        clock.format = "{:%H:%M}";
        clock.format-alt = "{:%Y-%m-%d}";

        cpu.format = "/ C {usage} ";
        memory.format = "/ M {}% ";
        disk = {
          interval = 30;
          format = "D {percentage_used}% ";
          path = "/";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-icons = ["" "" "" "" ""];
        };

        modules-left = [
          # "wlr/taskbar"
          "hyprland/window"
        ];

        modules-center = [
          "hyprland/workspaces"
        ];

        modules-right = [
          "pulseaudio"
          "bluetooth"
          "battery"
          "group/hardware"
          "network"
          "clock"
        ];

        "group/hardware" = {
          orientation = "horizontal";
          modules = [
            "disk"
            "cpu"
            "memory"
          ];
        };

        "hyprland/workspaces" = {
          on-click = "activate";
          active-only = false;
          format = "{icon} {}";
          format-icons = {
            urgent = "";
            active = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 18;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
          ignore-list = ["Alacritty"];
          rewrite = {
            "Firefox Web Browser" = "Firefox";
          };
        };

        "hyprland/window" = {
          separate-outputs = true;
          icon = true;
        };
      }];

      style = (builtins.readFile ./style.css);
    };
  };
}
