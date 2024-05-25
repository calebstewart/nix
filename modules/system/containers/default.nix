{lib, config, pkgs, ...}:
let
  cfg = config.modules.containers;
in {
  options.modules.containers = {
    enable = lib.mkEnableOption "containers";

    enableCompose = lib.mkOption {
      default = false;
    };

    dockerCompat = lib.mkOption {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = cfg.dockerCompat;
      dockerSocket.enable = cfg.dockerCompat;

      extraPackages = if cfg.enableCompose then with pkgs; [
        podman-compose
      ] else [];

      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    virtualisation.containers = {
      enable = true;

      containersConf.cniPlugins = if cfg.enableCompose then with pkgs; [
        cni-plugins
        dnsname-cni
      ] else [];
    };
  };
}
