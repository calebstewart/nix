{config, pkgs, lib, ...}: 
let
  cfg = config.modules.looking-glass;
in {
  options.modules.looking-glass = {
    enable = lib.mkEnableOption "looking-glass";

    # Allow the user to override the looking-glass-client package
    package = lib.mkOption {
      description = "Package providing the looking-glass-client";
      type = lib.types.package;

      # By default, we install B6 because nixpkgs provides B7 which is broken for me
      # However, we also need to apply a patch which isn't even released in B7-rc1
      # yet which enables Looking Glass to run in Wayland with fractional scaling.
      default = pkgs.looking-glass-client.overrideAttrs {
        version = "B6";

        src = pkgs.fetchFromGitHub {
          owner = "gnif";
          repo = "LookingGlass";
          rev = "B6";
          hash = "sha256-6vYbNmNJBCoU23nVculac24tHqH7F4AZVftIjL93WJU=";
          fetchSubmodules = true;
        };

        patches = [./patches/0001-client-wayland-Let-viewporter-use-full-wl_buffer.patch];
      };
    };

    # Options for using the KVM Frame Relay Kernel Module
    kvmfr = {
      enable = lib.mkEnableOption "kvmfr";

      owner = lib.mkOption {
        description = "Owner of the kvmfr device file(s)";
        default = "kvm";
        type = lib.types.str;
      };

      group = lib.mkOption {
        description = "Group of the kvmfr device file(s)";
        default = "kvm";
        type = lib.types.str;
      };

      package = lib.mkOption {
        description = "Package providing the looking-glass KVM frame-relay kernel module";
        default = config.boot.kernelPackages.kvmfr;
        type = lib.types.package;
      };

      sizeMB = lib.mkOption {
        description = "Size (in megabytes) of the frame-relay device (see: https://looking-glass.io/docs/B6/install/#determining-memory)";
        default = 32;
        type = lib.types.ints.positive;
      };
    };

    # Options for creating the /dev/shm shared memory file
    shm = {
      enable = lib.mkEnableOption "Shared Memory File";

      owner = lib.mkOption {
        description = "Owner of the shared memory file";
        default = "kvm";
        type = lib.types.str;
      };

      name = lib.mkOption {
        description = "Name of the shared memory file under /dev/shm";
        default = "looking-glass";
      };
    };

    # Client configuration (written to /etc/looking-glass-client.ini)
    settings = lib.mkOption {
      description = "Looking Glass client configuration";
      default = {};
      type = lib.types.submodule ./types/config;
    };
  };

  config = lib.mkIf cfg.enable {
    # Install looking glass
    environment.systemPackages = [cfg.package];
    boot.extraModulePackages = lib.lists.optional cfg.kvmfr.enable cfg.kvmfr.package;

    # Create the configuration file if requested
    environment.etc = {
      # Write the looking glass configuration
      "looking-glass-client.ini" = {
        text = lib.generators.toINI {} cfg.settings;
      };

      # Set the frame size if kvmfr is enabled
      "modprobe.d/kvmfr.conf" = {
        enable = cfg.kvmfr.enable;
        text = ''
          options kvmfr static_size_mb=${builtins.toString cfg.kvmfr.sizeMB}
        '';
      };

      # Load the kvmfr module at boot if enabled
      "modules-load.d/kvmfr.conf" = {
        enable = cfg.kvmfr.enable;
        text = ''
          # KVMFR Looking Glass Module
          kvmfr
        '';
      };
    };

    # Automatically apply permissions to the kvmfr device as requested
    services.udev.packages = lib.lists.optional cfg.kvmfr.enable (pkgs.writeTextFile {
      name = "99-kvmfr.rules";
      destination = "/etc/udev/rules.d/99-kvmfr.rules";
      text = ''
        SUBSYSTEM=="kvmfr", OWNER="${cfg.kvmfr.owner}", GROUP="${cfg.kvmfr.group}", MODE="0660"
      '';
    });

    # Create the /dev/shm file if requested
    systemd.tmpfiles.rules = lib.lists.optional cfg.shm.enable ''
      f /dev/shm/${cfg.shm.name} 0660 ${cfg.shm.owner} qemu-libvirtd -
    '';
  };
}
