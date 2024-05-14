{pkgs, lib, config, ...}:
let
  cfg = config.modules.obs;
in {
  options.modules.obs = { enable = lib.mkEnableOption "obs"; };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;

      plugins = [];
    };
  };
}
