{pkgs, lib, config, ...}:
let
  cfg = config.modules.rofi;

  # Custom script mode for Rofi for interacting with libvirt domains
  libvirtMode = pkgs.writeShellApplication {
    name = "rofi-libvirt-mode";

    runtimeInputs = with pkgs; [
      libvirt
      coreutils
      libnotify
      virt-viewer
      gnugrep
    ];

    text = builtins.readFile ./modes/libvirt.sh;
  };

  # Custom script mode for rofi for controlling bluetooth devices
  bluetoothMode = pkgs.writeShellApplication {
    name = "rofi-bluetooth-mode";

    runtimeInputs = with pkgs; [
      bluez
    ];

    text = builtins.readFile ./modes/bluetooth.sh;
  };
in {
  options.modules.rofi = {
    enable = lib.mkEnableOption "rofi";
    libvirt-mode.enable = lib.mkEnableOption "libvirt-mode";
    bluetooth-mode.enable = lib.mkEnableOption "bluetooth-mode";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.rofi-wayland] ++
    (lib.optional cfg.libvirt-mode.enable libvirtMode) ++
    (lib.optional cfg.bluetooth-mode.enable bluetoothMode);

    # Setup rofi colors
    # TODO: make these use the current colorscheme
    home.file.".config/rofi/colors.rasi".text = with config.colorScheme.palette; ''
    * {
      background: #${base00};
      background-alt: #${base01};
      foreground: #${base05};
      selected: #${base06};
      active: #${base03};
      urgent: #${base08};
    }
    '';

    home.file.".config/rofi/launcher.rasi".source = ./launcher.rasi;
  };
}
