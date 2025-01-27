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
        ".direnv"
      ];

      userName = user.fullName;
      userEmail = user.email;

      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519.pub";
        commit.gpgsign = true;

        url = {
          "git@github.com:" = {
            insteadOf = "https://github.com/";
          };
        };
      };

      includes = lib.attrsets.mapAttrsToList (name: alias: {
        condition = "gitdir:~/git/${name}/";
        contents.user = {
          email = lib.attrsets.attrByPath ["email"] user.email alias;
          name = lib.attrsets.attrByPath ["fullName"] user.fullName alias;
          signingkey = lib.attrsets.attrByPath ["signingkey"] "~/.ssh/id_ed25519.pub" alias;
        };
      }) user.aliases;
    };
  };
}
