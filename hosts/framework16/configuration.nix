# This file serves as a module-based system configuration entrypoint. It is separate from
# hardware-configuration and modules/system/configuration.nix to provide a way to configure
# system-level settings outside of home-manager in way specific to a host while not polluting
# hardware-configuration.nix. Generally, this should just set configuration options for modules
# under modules/system/*/default.nix.
{config, inputs, pkgs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
  ];

  config.modules = {
    systemd-boot.enable = true;
    virtualisation.enable = true;
    desktop-manager.enable = true;
    sound.enable = true;
    sshd.enable = false;
    users.enable = true;
    time.enable = true;
    security.enable = true;
    fingerprint.enable = true;
    nh.enable = true;

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

  config = {
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Enabling this explicitly prevents hibernation by adding the
    # 'nohibernate' kernel paramter.
    security.protectKernelImage = false;

    systemd.sleep.extraConfig = ''
      AllowHybridSleep=yes
      AllowSuspend=yes
      AllowHibernate=yes
    '';
  };
}
