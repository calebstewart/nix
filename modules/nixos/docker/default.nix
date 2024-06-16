{lib, config, ...}:
let
  cfg = config.modules.docker;
in {
  options.modules.docker = {
    enable = lib.mkEnableOption "docker";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
      rootless.enable = true;
      autoPrune.enable = true;
    };
  };
}
