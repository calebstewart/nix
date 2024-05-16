{lib, config, user, ...}:
let
  cfg = config.modules.git;
in {
  options.modules.git = { enable = lib.mkEnableOption "git"; };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;

      userName = user.fullName;
      userEmail = user.email;

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        gpg.format = "ssh";
      };
    };
  };
}
