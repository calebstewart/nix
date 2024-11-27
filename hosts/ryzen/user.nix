{ user, pkgs, config, ...}:
let
  # Scaling factor to use for rendering for all monitors
  scaling_factor = 1.25;

  # Default resolution of my desktop monitors
  resolution = {
    width = 3840;
    height = 2160;
  };

  # Resolution of monitors after scaling
  scaled_resolution = {
    width = builtins.floor (resolution.width / scaling_factor);
    height = builtins.floor (resolution.height / scaling_factor);
  };
in
{
  imports = [
    ../../modules/default.nix
  ];

  config.modules = {
    # Graphical User Interface (GUI)
    firefox.enable = true;
    alacritty.enable = true;
    eww.enable = false;
    dunst.enable = false;
    swaync.enable = false;
    wofi.enable = false;
    rofi.enable = true;
    obs.enable = true;
    pipewire.enable = true;

    waybar = {
      enable = false;
      includePaths = ["${config.xdg.configHome}/waybar/embermug.json"];
    };

    hyprland = {
      enable = true;
      swap_escape = false; # We use a nice keyboard :)
      
      monitors = [
        "desc:Dell Inc. DELL U2723QE 55L01P3,preferred,${builtins.toString scaled_resolution.width}x0,${builtins.toString scaling_factor}"
        "desc:Dell Inc. DELL U2718Q 4K8X7974188L,preferred,${builtins.toString (scaled_resolution.width*2)}x0,${builtins.toString scaling_factor}"
        "desc:Dell Inc. DELL U2723QE HXJ01P3,preferred,0x0,${builtins.toString scaling_factor}"
      ];
    };

    # Command Line Interface (CLI)
    neovim.enable = true;
    zsh.enable = true;
    git.enable = true;
    golang.enable = true;
    zoxide.enable = true;
    bat.enable = true;
    eza.enable = true;
    # gpg.enable = true;
    # direnv.enable = true;

    # System
    # xdg.enable = true;
    # packages.enable = true;
  };

  config = {
    # Enable support for my ember mug monitoring service
    programs.embermug = {
      enable              = true;
      systemd.enable = true;
      systemd.socket-activation = true;
      waybar.enable = true;

      settings = {
        socket-path = "/tmp/embermug.sock";

        service = {
          device-address = "D2:45:BF:D1:6C:E8";
          enable-notifications = true;
        };
      };
    };

    home.packages = with pkgs; [
      # Install ZSA Keymapp for programmer my Moonlander keyboard
      keymapp
      packer

      # ghidra
      # (cutter.withPlugins (ps: with ps; [
      #   jsdec
      #   rz-ghidra
      #   sigdb
      # ]))
      # (jd-gui.override (old: {
      #   gradle_6 = pkgs.gradle;
      # }))
      # (jadx.overrideAttrs (old: {
      #   nativeBuildInputs = [
      #     gradle
      #     jdk
      #     imagemagick
      #     makeBinaryWrapper
      #     copyDesktopItems
      #   ];

      #   patches = [
      #     ./jadx-no-native-deps.diff
      #   ];
      # }))
    ];
  };
}
