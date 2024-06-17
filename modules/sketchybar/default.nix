{lib, config, pkgs, ...}:
let
  cfg = config.modules.sketchybar;

  # Script called to get the current clock timestamp
  clock = pkgs.writeShellApplication {
    name = "clock";
    runtimeInputs = with pkgs; [ sketchybar ];

    text = ''
      #!/bin/sh

      sketchybar --set "$NAME" label="$(date '+%d/%m %H:%M')"
    '';
  };

  # Script called to get the current application title
  active_title = pkgs.writeShellApplication {
    name = "active-title";
    runtimeInputs = with pkgs; [ sketchybar ];

    text = ''
      #!/bin/sh

      if [ "$SENDER" = "front_app_switched" ]; then
        sketchybar --set "$NAME" label="$INFO"
      fi
    '';
  };

  # Script called to get the current battery percentage/icon
  battery = pkgs.writeShellApplication {
    name = "battery";
    runtimeInputs = with pkgs; [ sketchybar gnugrep coreutils ];

    text = ''
      #!/bin/sh

      PERCENTAGE="$(pmset -g batt | grep -Po '\d+%' | cut -d% -f1)"
      CHARGING="$(pmset -g batt | grep 'AC Power' || true)"

      if [ "$PERCENTAGE" = "" ]; then
        exit 0
      fi

      case "''${PERCENTAGE}" in
        9[0-9]|100) ICON=""
        ;;
        [6-8][0-9]) ICON=""
        ;;
        [3-5][0-9]) ICON=""
        ;;
        [1-2][0-9]) ICON=""
        ;;
        *) ICON=""
      esac

      if [[ "$CHARGING" != "" ]]; then
        ICON=""
      fi

      # The item invoking this script (name $NAME) will get its icon and label
      # updated with the current battery status
      sketchybar --set "$NAME" icon="$ICON" label="''${PERCENTAGE}%"
    '';
  };

  # Script called to get the current volume icon
  volume = pkgs.writeShellApplication {
    name = "volume";
    runtimeInputs = with pkgs; [ sketchybar ];

    text = ''
      #!/bin/sh

      # The volume_change event supplies a $INFO variable in which the current volume
      # percentage is passed to the script.

      if [ "$SENDER" = "volume_change" ]; then
        VOLUME="$INFO"

        case "$VOLUME" in
          [6-9][0-9]|100) ICON="󰕾"
          ;;
          [3-5][0-9]) ICON="󰖀"
          ;;
          [1-9]|[1-2][0-9]) ICON="󰕿"
          ;;
          *) ICON="󰖁"
        esac

        sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%"
      fi
    '';
  };

  # Wrap above plugins in a single plugin tree
  plugins = pkgs.symlinkJoin {
    name = "sketchybar-plugins";
    paths = [clock active_title battery volume];
  };
in {
  options.modules.sketchybar = {
    enable = lib.mkEnableOption "sketchybar";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."sketchybar/sketchybarrc" = {
      enable = true;
      executable = true;
      text = ''
        #!/bin/sh

        PLUGIN_DIR="${plugins}/bin"

        # Configure the main bar
        sketchybar --bar \
          position=top \
          height=44 \
          color=0x00${config.colorScheme.palette.base00} \
          border_color=0xFF${config.colorScheme.palette.base01}

        # Default values for all following components
        default=(
          padding_left=5
          padding_right=5
          icon.font="JetBrainsMono Nerd Font Mono:Bold:17.0"
          label.font="JetBrainsMono Nerd Font Mono:Bold:12.0"
          icon.color=0xff${config.colorScheme.palette.base05}
          label.color=0xff${config.colorScheme.palette.base05}
          icon.padding_left=4
          icon.padding_right=4
          label.padding_left=4
          label.padding_right=4
        )
        sketchybar --default "''${default[@]}"

        # Add space indicators for common spaces
        SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
        for i in "''${!SPACE_ICONS[@]}"
        do
          sid="$(($i+1))"
          space=(
            space="$sid"
            icon="''${SPACE_ICONS[i]}"
            icon.font="JetBrainsMono Nerd Font Mono:Bold:12.0"
            icon.color=0xff${config.colorScheme.palette.base04}
            icon.highlight_color=0xff${config.colorScheme.palette.base05}
            icon.padding_left=7
            icon.padding_right=7
            background.color=0x00${config.colorScheme.palette.base02}
            background.corner_radius=5
            background.height=25
            label.drawing=off
            click_script="yabai -m space --focus $sid"
          )
          sketchybar --add space space."$sid" left --set space."$sid" "''${space[@]}"
        done

        # Show the current application title on the left (after spaces)
        sketchybar --add item chevron left \
                   --set chevron icon= label.drawing=off \
                   --add item front_app left \
                   --set front_app icon.drawing=off script="$PLUGIN_DIR/active-title" \
                   --subscribe front_app front_app_switched

        # Show system status information on the right
        sketchybar --add item clock right \
                   --set clock update_freq=10 icon=  script="$PLUGIN_DIR/clock" \
                   --add item volume right \
                   --set volume script="$PLUGIN_DIR/volume" \
                   --subscribe volume volume_change \
                   --add item battery right \
                   --set battery update_freq=120 script="$PLUGIN_DIR/battery" \
                   --subscribe battery system_woke power_source_change

        ##### Force all scripts to run the first time (never do this in a script) #####
        sketchybar --update
      '';
    };
  };
}
