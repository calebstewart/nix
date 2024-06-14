{config, lib, ...}:
let
  cfg = config.modules.networking;
  wireguardPort = 45101;
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

    networking.firewall = {
      enable = true;
      logReversePathDrops = true;

      # wireguard trips rpfilter up
      extraCommands = ''
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport ${builtins.toString wireguardPort} -j RETURN
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport ${builtins.toString wireguardPort} -j RETURN
      '';
      extraStopCommands = ''
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport ${builtins.toString wireguardPort} -j RETURN || true
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport ${builtins.toString wireguardPort} -j RETURN || true
      '';
    };
  };
}
