{lib, config, user, ...}:
let
  cfg = config.modules.security;
in {
  options.modules.security = {
    enable = lib.mkEnableOption "security";
  };

  config = lib.mkIf cfg.enable {
    security = {
      sudo.enable = false;
      
      doas = {
        enable = true;
        extraRules = [{
          users = [user.name];
          keepEnv = true;
          persist = true;
        }];
      };

      # protectKernelImage = true;

      # Allow hyprlock to unlock the system
      pam.services.hyprlock = {};

      polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if ( action.id == "org.freedesktop.systemd1.manage-units" ||
               action.id == "org.freedesktop.systemd1.manage-unit-files" ||
               action.id == "org.freedesktop.policykey.exec" ) {
            return polkit.Result.AUTH_ADMIN_KEEP;
          }
        });
      '';
    };
  };
}
