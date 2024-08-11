# This file serves as a module-based system configuration entrypoint. It is separate from
# hardware-configuration and modules/system/configuration.nix to provide a way to configure
# system-level settings outside of home-manager in way specific to a host while not polluting
# hardware-configuration.nix. Generally, this should just set configuration options for modules
# under modules/system/*/default.nix.
{config, pkgs, user, ...}:
let
in {
  config.modules = {
    systemd-boot.enable = true;
    desktop-manager.enable = false;
    sound.enable = true;
    sshd.enable = true;
    users.enable = true;
    time.enable = true;
    security.enable = true;
    nh.enable = true;

    networking = {
      enable = true;
    };
  };
}
