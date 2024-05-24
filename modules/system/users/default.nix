{lib, config, user, pkgs, ...}:
let
  cfg = config.modules.users;

  networkGroups = if config.modules.networking.enable then ["networkmanager"] else [];
  virtGroups = if config.modules.virtualisation.enable then ["libvirtd"] else [];
in {
  options.modules.users = {
    enable = lib.mkEnableOption "users";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;

    # Setup our users
    users.users.${user.name} = {
      description = user.fullName;
      isNormalUser = true;
      extraGroups = ["wheel" "input"] ++ networkGroups ++ virtGroups;
      createHome = true;
      shell = pkgs.zsh;
    };

    environment.variables = {
      XDG_DATA_HOME = "$HOME/.local/share";
    };
  };
}
