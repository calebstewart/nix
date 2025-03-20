{lib, config, ...}:
let
  cfg = config.modules.time;
in {
  options.modules.time = {
    enable = lib.mkEnableOption "time";
    zone = lib.mkOption {
      default = "America/Chicago";
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = cfg.zone;
  };
}
