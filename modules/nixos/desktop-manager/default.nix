{lib, config, user, pkgs, inputs, ...}:
let
  cfg = config.modules.desktop-manager;
in {
  options.modules.desktop-manager = {
    enable = lib.mkEnableOption "desktop-manager";
  };

  config = lib.mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        # displayManager.gdm.enable = true;
      };

      greetd = {
        enable = true;
        settings =
        let 
          tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
          # command = "${pkgs.systemd}/bin/systemctl --user --wait start hyprland-session.target";
          command = "${pkgs.hyprland}/bin/Hyprland";
        in {
          initial_session = {
            inherit command;
            user = user.name;
          };

          default_session = {
            command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd '${command}'";
            user = "greeter";
          };
        };
      };

      libinput.enable = true;
    };

    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        roboto
        openmoji-color
        font-awesome
      ];

      fontconfig = {
        hinting.autohint = true;
        defaultFonts = {
          emoji = ["Noto Color Emoji"];
        };
      };
    };

    # Setup XDG portal(s)
    xdg.autostart.enable = true;
    xdg.portal = {
      enable = true;
      configPackages = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
    };

    programs.hyprland.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        mesa.opencl
        rocmPackages.clr.icd
      ];
    };

    security.pam.services.swaylock = {
      fprintAuth = config.modules.fingerprint.enable;
    };

    security.pam.services.gdm = {
      fprintAuth = config.modules.fingerprint.enable;
    };
  };
}
