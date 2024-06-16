{lib, config, ...}:
let
  cfg = config.modules.fingerprint;
in {
  options.modules.fingerprint = {
    enable = lib.mkEnableOption "fingerprint";
  };

  config = lib.mkIf cfg.enable {
    services.fprintd = {
      enable = true;
      tod.enable = false;
    };
  };
}
