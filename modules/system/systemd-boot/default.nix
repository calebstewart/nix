{config, lib, ...}:
let
  cfg = config.modules.systemd-boot;
in {
  options.modules.systemd-boot = {
    enable = lib.mkEnableOption "systemd-boot";
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
