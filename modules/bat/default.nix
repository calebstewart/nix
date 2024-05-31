{lib, config, pkgs, ...}:
let
  cfg = config.modules.bat;
in {
  options.modules.bat = {
    enable = lib.mkEnableOption "bat";
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;

      config = {
        theme = "base16";
        style = "numbers";
      };
    };

    home.packages = with pkgs; [
      bat-extras.batman
    ];

    home.shellAliases = {
      "cat" = "bat";
      "man" = "batman";
    };
  };
}
