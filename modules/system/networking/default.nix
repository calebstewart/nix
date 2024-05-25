{config, lib, ...}:
let
  cfg = config.modules.networking;
in {
  options.modules.networking = {
    enable = lib.mkEnableOption "networking";
    enableBluetooth = lib.mkOption {
      default = false;
    };
  };

  config = {
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = cfg.enableBluetooth;
  };
}
