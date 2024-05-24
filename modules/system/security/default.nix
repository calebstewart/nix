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

      protectKernelImage = true;
    };
  };
}
