{lib, config, ...}:
let
  cfg = config.modules.zoxide;
in {
  options.modules.zoxide = {
    enable = lib.mkEnableOption "zoxide";
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = config.modules.zsh.enable;

      options = [
        "--cmd" "cd"
      ];
    };
  };
}
