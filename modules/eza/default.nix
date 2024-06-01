{lib, config, ...}:
let
  cfg = config.modules.eza;
in {
  options.modules.eza = {
    enable = lib.mkEnableOption "eza";
  };

  config = lib.mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = true;

      extraOptions = [
        "--group-directories-first"
      ];
    };
    
    home.shellAliases = {
      "tree" = "ls -T";
    };
  };
}
