{inputs, pkgs, lib, config, user, ...}:
let
  cfg = config.modules.hyprland;

  modifier = "SUPER";
  terminal = "alacritty";
  floating_term_class = "floating-term";

  rofi_theme = "$HOME/.config/rofi/launcher.rasi";
  # menu_command = "rofi -show drun -theme ${rofi_theme}";
  menu_command = lib.escapeShellArgs [
    (lib.getExe inputs.stew-shell.packages.${pkgs.system}.default)
    "popup"
    "toggle"
    "ApplicationLauncher"
  ];
  libvirt_menu = "rofi -show libvirt -theme ${rofi_theme} -modes libvirt:${inputs.rofi-libvirt-mode.packages.${pkgs.system}.default}/bin/rofi-libvirt-mode";
  screenshot_command = "grimblast copy area --notify";
  printscreen_command = "grimblast copy output --notify";

  powermenu = pkgs.writeShellApplication {
    name = "powermenu";
    runtimeInputs = [pkgs.jq pkgs.hyprland pkgs.systemd];
    text = builtins.readFile ./power-menu.sh;
  };
  powermenu_command = "rofi -show powermenu -theme ${rofi_theme} -modes powermenu:${powermenu}/bin/powermenu";

  toggleSpecial = {class, command, specialWorkspace, runtimeInputs}: pkgs.writeShellApplication {
    name = "toggle";
    runtimeInputs = [pkgs.jq pkgs.hyprland] ++ runtimeInputs;

    text = ''
      existing=$(hyprctl clients -j | jq -r '.[] | select(.class == "${class}") | .address' && true)
      if [ -z "$existing" ]; then
        ${command}
      else
        hyprctl dispatch togglespecialworkspace "${specialWorkspace}"
      fi
    '';
  };

  toggleFloatTerm = toggleSpecial rec {
    specialWorkspace = "shell";
    class = "${floating_term_class}:shell";
    command = "exec alacritty --class ${class}";
    runtimeInputs = with pkgs; [ alacritty ];
  };

  togglePythonTerm = toggleSpecial rec {
    specialWorkspace = "python";
    class = "${floating_term_class}:python";
    command = ''exec alacritty --class "${class}" -e python'';
    runtimeInputs = with pkgs; [ alacritty python312 ];
  };

  toggleSlack = toggleSpecial {
    specialWorkspace = "slack";
    class = "Slack";
    command = "exec slack";
    runtimeInputs = with pkgs; [ slack ];
  };

  mkBinding = {extraModifier ? "", key, executor ? "exec", command ? ""}:
    "${modifier} ${extraModifier}, ${key}, ${executor}, ${command}";
in {
  options.modules.hyprland = {
    enable = lib.mkEnableOption "hyprland";

    monitors = lib.mkOption {
      default = [];
    };

    swap_escape = lib.mkOption {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      swaybg
      wl-clipboard
      slurp
      grimblast
      brightnessctl
      polkit_gnome
      showmethekey
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      systemd = {
        enable = true;
        
        # The default set of exposed environment variables is not sufficient
        # to make Electron understand it should use Wayland instead of XWayland.
        # This set of variables functions properly when graphical applications
        # are opened through a SystemD user service.
        variables = [
          # Default value:
          "DISPLAY"
          "HYPRLAND_INSTANCE_SIGNATURE"
          "WAYLAND_DISPLAY"
          "XDG_CURRENT_DESKTOP"

          # Non-standard variables:
          "XDG_SESSION_ID"
          "XDG_SEAT"
          "XDG_SESSION_TYPE"
          "XDG_BACKEND"
          "XDG_VTNR"
        ];
      };

      plugins = with pkgs.hyprlandPlugins; [
        hyprsplit
      ];

      settings = {
        "$mod" = modifier;

        monitor = [",preferred,auto,1"] ++ cfg.monitors;
        # master.new_is_master = true;
        gestures.workspace_swipe = true;

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        exec-once = [
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        ];

        input = {
          kb_layout = "us";
          kb_options = if cfg.swap_escape then "caps:swapescape" else "";
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

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(${config.colorScheme.palette.base02}ee)";
          };

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
            "windows, 1, 5, myBezier, popin 80%"
            "windowsOut, 1, 5, myBezier, slidefade"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
            "layers, 1, 7, default, slide"
            "specialWorkspace, 1, 6, default, slidefadevert -20%"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
          # no_gaps_when_only = 1;
        };

        layerrule = [
          # Disable background animations
          "noanim,hyprpaper"
          "animation fade in,PopupCloser"
          "animation slide top,LockerShade"
          "animation slide top,SystemMenu"
          "animation slide left,ApplicationLauncher"
          "animation slide right,NotificationPopup"
          "animation slide right,SettingsMenu"
        ];

        workspace = [
          # Smart gaps (remove gaps when only tiled window)
          "w[tv1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
        ];

        windowrulev2 = [
          "suppressevent maximize, class:.*"
          "idleinhibit fullscreen, class:.*"

          "float,class:(showmethekey-gtk)"
          "size 100% 10%,class:(showmethekey-gtk)"
          "move 0% 90%,class:(showmethekey-gtk)"
          "noborder,class:(showmethekey-gtk)"
          "animation slide bottom,class:(showmethekey-gtk)"

          "float,class:(polkit-gnome-authentication-agent-1)"
          "move 37% 2%,class:(polkit-gnome-authentication-agent)"
          "size 25% 10%,class:(polkit-gnome-authentication-agent)"
          # "center,class:(polkit-gnome-authentication-agent-1)"
          "pin,class:(polkit-gnome-authentication-agent-1)"
          "stayfocused,class:(polkit-gnome-authentication-agent-1)"
          "animation slide top,class:(polkit-gnome-authentication-agent-1)"
          "workspace special:polkit,class:(polkit-gnome-authentication-agent)"

          "float,class:^(${floating_term_class})"
          "move 33% 2%,class:^(${floating_term_class})"
          "size 33% 25%,class:^(${floating_term_class})"
          "opacity 0.98,class:^(${floating_term_class})"
          "stayfocused,class:^(${floating_term_class})"
          "animation slide top,class:^(${floating_term_class})"

          # Make slack into a floating drop-down panel
          "float,class:^(Slack)$"
          "move 15% 2%,class:^(Slack)$"
          "size 70% 75%,class:^(Slack)$"
          "animation slide top,class:^(Slack)$"
          "workspace special:slack,class:^(Slack)$"

          "workspace special:shell,class:^(${floating_term_class}:shell)$"
          "workspace special:python,class:^(${floating_term_class}:python)$"

          # Remove borders when only tiled window (part of "smart gaps")
          "bordersize 0, floating:0, onworkspace:w[tv1]"
          "rounding 0, floating:0, onworkspace:w[tv1]"
          "bordersize 0, floating:0, onworkspace:f[1]"
          "rounding 0, floating:0, onworkspace:f[1]"
        ];

        bind = [
          "${modifier}, Return, exec, ${terminal}"
          "${modifier}, Q, killactive,"
          "${modifier} SHIFT, E, exec, ${powermenu_command}"
          "${modifier} SHIFT, Space, togglefloating,"
          "${modifier}, D, exec, ${menu_command}"
          "${modifier}, V, togglesplit,"
          "${modifier} SHIFT, R, exec, ${screenshot_command}"
          "${modifier} SHIFT, P, exec, ${printscreen_command}"
          "${modifier}, Backspace, exec, loginctl lock-session"
          "${modifier}, U, exec, uuidgen | wl-copy"
          "${modifier} SHIFT, F, fullscreen"
          "${modifier}, M, exec, ${libvirt_menu}"
          
          "${modifier}, h, movefocus, l"
          "${modifier}, l, movefocus, r"
          "${modifier}, k, movefocus, u"
          "${modifier}, j, movefocus, d"

          "${modifier} SHIFT, h, movewindow, l"
          "${modifier} SHIFT, l, movewindow, r"
          "${modifier} SHIFT, k, movewindow, u"
          "${modifier} SHIFT, j, movewindow, d"

          "${modifier}, 1, split:workspace, 1"
          "${modifier}, 2, split:workspace, 2"
          "${modifier}, 3, split:workspace, 3"
          "${modifier}, 4, split:workspace, 4"
          "${modifier}, 5, split:workspace, 5"
          "${modifier}, 6, split:workspace, 6"
          "${modifier}, 7, split:workspace, 7"
          "${modifier}, 8, split:workspace, 8"
          "${modifier}, 9, split:workspace, 9"
          "${modifier}, 0, split:workspace, 10"

          "${modifier} SHIFT, 1, split:movetoworkspace, 1"
          "${modifier} SHIFT, 2, split:movetoworkspace, 2"
          "${modifier} SHIFT, 3, split:movetoworkspace, 3"
          "${modifier} SHIFT, 4, split:movetoworkspace, 4"
          "${modifier} SHIFT, 5, split:movetoworkspace, 5"
          "${modifier} SHIFT, 6, split:movetoworkspace, 6"
          "${modifier} SHIFT, 7, split:movetoworkspace, 7"
          "${modifier} SHIFT, 8, split:movetoworkspace, 8"
          "${modifier} SHIFT, 9, split:movetoworkspace, 9"
          "${modifier} SHIFT, 0, split:movetoworkspace, 10"

          "${modifier}, t, exec, ${toggleFloatTerm}/bin/toggle"
          "${modifier}, p, exec, ${togglePythonTerm}/bin/toggle"
          "${modifier}, s, exec, ${toggleSlack}/bin/toggle"
        ];

        bindm = [
          "${modifier},mouse:272,movewindow"
        ];

        source = "~/.config/hypr/config.d/*.conf";
      };

    };

    # Write an empty config so that the source directive doesn't die when no other modules
    # write configurations here.
    home.file.".config/hypr/config.d/00-empty.conf".text = "";

    # Configure the idle service to automatically lock the session and turn off the
    # display when left idle. These timeouts are aggressive as hell (60 seconds of
    # inactivity to full display off), but that's how I like it. Full screen windows
    # like video players will inhibit the idle, and if I'm not watching a video,
    # I'm almost certainly interacting with my computer.
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          before_sleep_cmd = "loginctl lock-session";
          lock_cmd = lib.escapeShellArgs [
            (lib.getExe inputs.stew-shell.packages.${pkgs.system}.default)
            "lock"
          ];
          # lock_cmd = "pidof hyprlock || hyprlock";
        };

        listener = [
          {
            # timeout = 150;
            timeout = 30;
            on-timeout = "brightnessctl --save set 10";
            on-resume = "brightnessctl --restore";
          }
          {
            # timeout = 300;
            timeout = 45;
            on-timeout = "loginctl lock-session";
          }
          {
            # timeout = 330;
            timeout = 60;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    # Gammastep is my preferred gamma correction service. However, it causes flickering
    # for some reason, and I can't diagnose it. wlsunset will technically work, but
    # it switches abruptly with no fade, and I hate that a lot. So much in fact that
    # I'm willing to forego all gamma correction until I can get gammastep to work. :(
    services.gammastep = {
      enable = false;
      provider = "manual";
      latitude = 38.907908091478724;
      longitude = -77.03843737519826;
    };

    # Hyprpaper manages the desktop background
    services.hyprpaper = {
      enable = true;

      settings = {
        ipc = "off";
        splash = false;
        splash_offset = 2.0;

        preload = [ "/home/${user.name}/.config/hypr/wallpaper.jpg" ];
        wallpaper = [ ",/home/${user.name}/.config/hypr/wallpaper.jpg" ];
      };
    };

    # Configure the lock screen
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          disable_loading_bar = true;
          grace = 5;
        };

        background = [{
          # path = "/home/${user.name}/.config/hypr/wallpaper.jpg";
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }];

        input-field = with config.colorScheme.palette; [{
          size = "250, 60";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.15;
          dots_center = true;
          outer_color = "rgb(${base02})";
          inner_color = "rgb(${base00})";
          font_color = "rgb(${base05})";
          check_color = "rgb(${base0A})";
          fail_color = "rgb(${base08})";
          capslock_color = "rgb(${base09})";
          bothlock_color = "rgb(${base09})";
          numlock_color = -1;
          swap_font_color = false;
          fail_text = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
          fail_transition = 500;
          fade_on_empty = true;
          font_family = "JetBrains Mono Nerd Font Mono";
          placeholder_text = ''<i><span foreground="##${base06}">Password...</span></i>'';
          hide_input = false;
          position = "0, -120";
          halign = "center";
          valign = "center";
        }];

        label = with config.colorScheme.palette; [
          {
            text = ''cmd[update:1000] date +"%H:%M"'';
            color = "rgb(${base05})";
            font_size = 120;
            font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
            position = "0, -300";
            halign = "center";
            valign = "top";
            shadow_passes = 3;
            shadow_size = 8;
          }
        ];
      };
    };

    systemd.user.services.stew-shell = {
      Unit = {
        Description = "Desktop Shell User Interface";
      };

      Service = {
        Type = "simple";
        ExecStart = lib.getExe inputs.stew-shell.packages.${pkgs.system}.default;
        Restart = "on-failure";
      };

      Install.WantedBy = ["hyprland-session.target"];
    };

    systemd.user.services.autologin-locker = {
      Unit = {
        Description = "Locks the session during initial bootup after auto-login from greetd";
        After = ["waybar.service" "hyprpaper.service"];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.hyprlock}/bin/hyprlock --immediate";
      };

      Install.WantedBy = ["hyprland-session.target"];
    };

    programs.wlogout = {
      enable = true;

      layout = [
        {
          label = "lock";
          action = "loginctl lock-session";
          text = "Lock Screen";
          keybind = "l";
        }
        {
          label = "logout";
          action = "pkill Hyprland";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
      ];

      # style = with config.colorScheme.palette; ''
      # window {
      #   background-color: #${base00};
      # }

      # button {
      #   color: #${base05};
      #   border-color: #${base01};
      #   text-decoration-color: #${base05};
      #   background-color: #${base00};
      #   border: 1px solid;
      #   background-repeat: no-repeat;
      #   background-position: center;
      #   background-size: 25%;
      # }

      # button:focus, button:active, button:hover {
      #   background-color: #${base02};
      #   outline-style: none;
      # }
      # '';
    };


    gtk = {
      enable = true;

      cursorTheme = {
        name = "catppuccin-mocha-dark-cursors";
        package = pkgs.catppuccin-cursors.mochaDark;
        # package = pkgs.catppuccin-cursors.mochaDark.overrideAttrs (old: {
        #   preBuild = ''
        #     ${lib.getExe pkgs.gnused} -i 's/NOMINAL_SIZE=24/NOMINAL_SIZE=32/g' ./scripts/build-xcursor-plasmasvg
        #   '';
        # });
      };

      theme = let
        nix-colors-lib = inputs.nix-colors.lib.contrib {
          inherit pkgs;
        };
      in {
        name = config.colorScheme.slug;
        package = nix-colors-lib.gtkThemeFromScheme {
          scheme = config.colorScheme;
        };
      };
      
      iconTheme = {
        name = "Papirus";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "blue";
        };
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
    };

    home.pointerCursor = {
      gtk.enable = true;

      name = "catppuccin-mocha-dark-cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
    };

    home.file.".config/hypr/wallpaper.jpg".source = ../../wallpapers/spaceman.jpg;

    # Ensure that the systemd session has access to home-manager session variables.
    # This means that hyprland in turn has access to these variables.
    systemd.user.sessionVariables = config.home.sessionVariables;
  };
}
