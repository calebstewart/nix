{inputs, config, lib, pkgs, ...}:
let
  cfg = config.modules.nh;
in {
  options.modules.nh = {
    enable = lib.mkEnableOption "nh";
  };

  config = lib.mkIf cfg.enable {
    # Enable the nix helper
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 5";
      flake = "/home/caleb/git/nix";

      # FIXME: Using this fork of nh which supports doas until the PR is merged:
      #        https://github.com/viperML/nh/pull/92
      package = inputs.nh-extra-privesc.packages.${pkgs.system}.default;
    };
  };
}
