{lib, config, ...}:
let
  cfg = config.modules.git;
in {
  options.modules.git = { enable = lib.mkEnableOption "git"; };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;

      userName = "Caleb Stewart";
      userEmail = "caleb.stewart94@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        gpg.format = "ssh";
      };
    };
  };
}
