{lib, config, user, ...}:
let
  cfg = config.modules.git;
in {
  options.modules.git = { enable = lib.mkEnableOption "git"; };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      ignores = [
        ".envrc"
      ];

      userName = user.fullName;
      userEmail = user.email;

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        gpg.format = "ssh";

        # url = {
        #   "git@github.com:" = {
        #     insteadOf = "https://github.com/";
        #   };
        # };
      };

      includes = lib.attrsets.mapAttrsToList (name: alias: {
        condition = "gitdir:~/git/${name}";
        contents.user = {
          email = lib.attrsets.attrByPath ["email"] user.email alias;
          name = lib.attrsets.attrByPath ["fullName"] user.fullName alias;
        };
      }) user.aliases;
    };
  };
}
