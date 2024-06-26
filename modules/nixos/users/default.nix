{lib, config, user, pkgs, ...}:
let
  cfg = config.modules.users;
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
      extraGroups = ["wheel" "dialout"] ++
        lib.optional config.modules.networking.enable "networkmanager" ++
        lib.optional config.modules.virtualisation.enable "libvirtd" ++
        lib.optional config.modules.containers.enable "podman" ++
        lib.optional config.modules.docker.enable "docker";
      createHome = true;
      shell = pkgs.zsh;
    };

    environment.variables = {
      XDG_DATA_HOME = "$HOME/.local/share";
    };
  };
}
