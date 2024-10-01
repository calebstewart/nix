# This file serves as a module-based system configuration entrypoint. It is separate from
# hardware-configuration and modules/system/configuration.nix to provide a way to configure
# system-level settings outside of home-manager in way specific to a host while not polluting
# hardware-configuration.nix. Generally, this should just set configuration options for modules
# under modules/system/*/default.nix.
{config, pkgs, user, ...}:
let
  mkLibvirtDomain = {name, src}: pkgs.stdenv.mkDerivation {
    inherit name src;

    buildInputs = with pkgs; [
      libvirt
    ];

    buildPhase = ''
      virt-xml-validate $src/domain.xml
    '';

    installPhase = ''
      mkdir -p $out/etc/libvirt/hooks/qemu.d/${name}
      mkdir -p $out/var/lib/libvirt/qemu

      if [ -d "$src/hooks" ]; then
        cp -r $src/hooks/* $out/etc/libvirt/qemu.d/${name}/
      fi

      cp $src/domain.xml $out/var/lib/libvirt/qemu/${name}.xml
    '';
  };
in {
  config.modules = {
    systemd-boot.enable = true;
    virtualisation.enable = true;
    desktop-manager.enable = true;
    sound.enable = true;
    sshd.enable = true;
    users.enable = true;
    time.enable = true;
    security.enable = true;
    nh.enable = true;

    networking = {
      enable = true;
      enableBluetooth = true;
    };

    containers = {
      enable = true;
      enableCompose = false;
      dockerCompat = false;
    };

    docker = {
      enable = true;
    };

    looking-glass = {
      enable = true;

      kvmfr = {
        enable = true;
        owner = user.name;
        sizeMB = 128;
      };

      settings = {
        app.shmFile = "/dev/kvmfr0";
        input.escapeKey = "KEY_RIGHTCTRL";

        win = {
          fullScreen = true;
          noScreensaver = true;
          showFPS = true;
        };
      };
    };
  };

  config = {
    nixpkgs.config.rocmSupport = true;

    programs.gamemode.enable = true;

    programs.gamescope = {
      enable = true;
      # capSysNice = true;
    };

    programs.steam = {
      enable = true;

      remotePlay.openFirewall = true;
      # dedicatedServer.openFirewall = true;
      # localNetworkGameTransfers.openFirewall = true;
    };

  };
}
