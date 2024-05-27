{lib, config, pkgs, inputs, ...}:
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
        displayManager.gdm.enable = true;
      };

      libinput.enable = true;
    };

    fonts = {
      packages = with pkgs; [
        jetbrains-mono
        roboto
        openmoji-color
        (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      ];

      fontconfig = {
        hinting.autohint = true;
        defaultFonts = {
          emoji = ["OpenMoji Color"];
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
        inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland
      ];
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
        inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland
      ];
    };

    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    hardware.opengl = {
      enable = true;
      driSupport = true;
    };

    security.pam.services.swaylock = {
      fprintAuth = config.modules.fingerprint.enable;
    };

    security.pam.services.gdm = {
      fprintAuth = config.modules.fingerprint.enable;
    };
  };
}
