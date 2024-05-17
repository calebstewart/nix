{inputs, pkgs, lib, config, ...}:
let
  cfg = config.modules.hyprland;

  modifier = "SUPER";
  terminal = "alacritty";

  menu_command = "rofi -show drun -theme $HOME/.config/rofi/launcher.rasi";
  screenshot_command = "grimblast copy area --notify";
  printscreen_command = "grimblast copy output --notify";

  mkBinding = {extraModifier ? "", key, executor ? "exec", command ? ""}:
    "${modifier} ${extraModifier}, ${key}, ${executor}, ${command}";
in {
  options.modules.hyprland = { enable = lib.mkEnableOption "hyprland"; };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      swaybg
      wlsunset
      wl-clipboard
      hyprland
      slurp
      grim
      grimblast
      wlogout
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        monitor = ",preferred,auto,1";
        master.new_is_master = true;
        gestures.workspace_swipe = true;

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        exec-once = [
          "swaybg -i $HOME/.config/hypr/wallpaper"
          "wlsunset -l 23 -L 46"
          "waybar"
          "dunst"
        ];


        input = {
          kb_layout = "us";
          kb_options = "caps:swapescape";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad.natural_scroll = true;
        };

        general = with config.colorScheme.palette; {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 1;
          "col.active_border" = "rgba(${base0D}ee) rgba(${base0E}ee) 45deg";
          "col.inactive_border" = "rgba(${base05}aa)";
          layout = "dwindle";
          allow_tearing = false;
        };

        decoration = {
          rounding = 2;
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(${config.colorScheme.palette.base02}ee)";

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
        };

        animations = {
          enabled = true;

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
            "layers, 1, 7, default, slide"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        windowrulev2 = [
          "suppressevent maximize, class:.*"
        ];

        bindt = [
          ", Super_L, exec, pkill -SIGUSR1 waybar"
        ];

        bindrt = [
          "SUPER, Super_L, exec, pkill -SIGUSR1 waybar"
        ];

        bind = [
          "${modifier}, Return, exec, ${terminal}"
          "${modifier}, Q, killactive,"
          "${modifier} SHIFT, E, exit,"
          "${modifier} SHIFT, Space, togglefloating,"
          "${modifier}, D, exec, ${menu_command}"
          "${modifier}, P, pseudo,"
          "${modifier}, V, togglesplit,"
          "${modifier} SHIFT, R, exec, ${screenshot_command}"
          "${modifier} SHIFT, P, exec, ${printscreen_command}"
          
          "${modifier}, h, movefocus, l"
          "${modifier}, l, movefocus, r"
          "${modifier}, k, movefocus, u"
          "${modifier}, j, movefocus, d"

          "${modifier}, 1, workspace, 1"
          "${modifier}, 2, workspace, 2"
          "${modifier}, 3, workspace, 3"
          "${modifier}, 4, workspace, 4"
          "${modifier}, 5, workspace, 5"
          "${modifier}, 6, workspace, 6"
          "${modifier}, 7, workspace, 7"
          "${modifier}, 8, workspace, 8"
          "${modifier}, 9, workspace, 9"
          "${modifier}, 0, workspace, 10"

          "${modifier} SHIFT, 1, movetoworkspace, 1"
          "${modifier} SHIFT, 2, movetoworkspace, 2"
          "${modifier} SHIFT, 3, movetoworkspace, 3"
          "${modifier} SHIFT, 4, movetoworkspace, 4"
          "${modifier} SHIFT, 5, movetoworkspace, 5"
          "${modifier} SHIFT, 6, movetoworkspace, 6"
          "${modifier} SHIFT, 7, movetoworkspace, 7"
          "${modifier} SHIFT, 8, movetoworkspace, 8"
          "${modifier} SHIFT, 9, movetoworkspace, 9"
          "${modifier} SHIFT, 0, movetoworkspace, 10"
        ];
      };

    };

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;

      settings = with config.colorScheme.palette; {
        screenshots = true;
        fade-in = 1;
        effect-blur = "6x2";

        inside-color = "${base00}";
        inside-clear-color = "${base0D}";
        inside-caps-lock-color = "${base09}";
        inside-ver-color = "${base0A}";
        inside-wrong-color = "${base08}";
        
        line-color = "${base01}";
        line-clear-color = "${base01}";
        line-caps-lock-color = "${base01}";
        line-ver-color = "${base01}";
        line-wrong-color = "${base01}";

        ring-color = "${base02}";
        ring-clear-color = "${base02}";
        ring-caps-lock-color = "${base02}";
        ring-ver-color = "${base02}";
        ring-wrong-color = "${base02}";

        text-color = "${base05}";
        text-clear-color = "${base06}";
        text-caps-lock-color = "${base05}";
        text-ver-color = "${base04}";
        text-wrong-color = "${base06}";

        key-hl-color = "${base0F}";
        bs-hl-color = "${base0E}";
      };
    };

    home.file.".config/hypr/wallpaper".source = ./spaceman.jpg;
  };
}
