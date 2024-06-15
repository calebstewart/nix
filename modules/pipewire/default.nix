{pkgs, lib, config, ...}:
let
  cfg = config.modules.pipewire;
in {
  options.modules.pipewire = {
    enable = lib.mkEnableOption "pipewire";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ pwvucontrol ];

    # Override the pwvucontrol desktop file to give a better name
    # and provide an icon.
    xdg.desktopEntries = {
      "com.saivert.pwvucontrol" = {
        name = "PipeWire Control";
        genericName = "Sound Settings";
        exec = "pwvucontrol %U";
        terminal = false;
        categories = ["AudioVideo" "Audio"];
        icon = ./icon.png;
      };
    };
  };
}
