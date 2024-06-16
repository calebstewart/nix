{lib, config, ...}:
let
  cfg = config.modules.time;
in {
  options.modules.time = {
    enable = lib.mkEnableOption "time";
    zone = lib.mkOption {
      default = "America/New_York";
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = cfg.zone;
  };
}
