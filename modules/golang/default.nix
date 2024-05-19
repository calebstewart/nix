{config, lib, ...}:
let
  cfg = config.modules.golang;
in {
  options.modules.golang = {enable = lib.mkEnableOption "golang"; };

  config = lib.mkIf cfg.enable {
    programs.go = {
      enable = true;
      goBin = ".local/bin.go";
      goPath = ".local/share/go";
    };
  };
}
