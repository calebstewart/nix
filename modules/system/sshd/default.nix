{lib, config, user, ...}:
let
  cfg = config.modules.sshd;
in {
  options.modules.sshd = {
    enable = lib.mkEnableOption "sshd";

    address = lib.mkOption {
      default = "0.0.0.0";
    };

    port = lib.mkOption {
      default = 61358;
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [cfg.port];
      startWhenNeeded = true;
      openFirewall = true;

      listenAddresses = [
        {
          addr = cfg.address;
          port = cfg.port; 
        }
      ];

      settings = {
        UsePAM = false;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AllowUsers = [user.name];
      };
    };
  };
}
