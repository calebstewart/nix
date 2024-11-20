{config, pkgs, lib, ...}:
let
  cfg = config.services.nordvpn;
  defaultNordvpnPackage = pkgs.callPackage (import ./nordvpn.nix) {};
in {
  options.services.nordvpn = {
    enable = lib.mkEnableOption "nordvpn";
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "List of users automatically added to the nordvpn group";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = defaultNordvpnPackage;
      description = "Nordvpn Client Package";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.checkReversePath = false;
    environment.systemPackages = [cfg.package];
    users.groups.nordvpn = {
      members = cfg.users;
    };
    
    systemd.services.nordvpn = {
      description = "NordVPN Daemon";
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/nordvpnd";
        ExecStartPre = "${cfg.package}/bin/nordvpnd-pre-start";
        NonBlocking = true;
        KillMode = "process";
        Restart = "on-failure";
        RestartSec = 5;
        RuntimeDirectory = "nordvpn";
        RuntimeDirectoryMode = "0750";
        Group = "nordvpn";
      };
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];
      wants = ["network-online.target"];
    };
  };
}
