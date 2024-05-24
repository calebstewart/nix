# This file serves as a module-based system configuration entrypoint. It is separate from
# hardware-configuration and modules/system/configuration.nix to provide a way to configure
# system-level settings outside of home-manager in way specific to a host while not polluting
# hardware-configuration.nix. Generally, this should just set configuration options for modules
# under modules/system/*/default.nix.
{config, ...}: {
  config.modules = {
    systemd-boot.enable = true;
    virtualisation.enable = true;
    desktop-manager.enable = true;
    sound.enable = true;
    sshd.enable = false;
    users.enable = true;
    time.enable = true;
    security.enable = true;

    networking = {
      enable = true;
      enableBluetooth = true;
    };

    containers = {
      enable = true;
      enableCompose = true;
      dockerCompat = true;
    };
  };
}
