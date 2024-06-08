{config, pkgs, lib, ...}: 
let
  cfg = config.modules.looking-glass;
in {
  options.modules.looking-glass = {
    enable = lib.mkEnableOption "looking-glass";

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

    kvmfr = {
      enable = lib.mkEnableOption "kvmfr";

      owner = lib.mkOption {
        description = "Owner of the kvmfr device file(s)";
        default = "kvm";
        type = lib.types.str;
      };

      package = lib.mkOption {
        description = "Package providing the looking-glass KVM frame-relay kernel module";
        default = config.boot.kernelPackages.kvmfr;
        type = lib.types.package;
      };

      sizeMB = lib.mkOption {
        description = "Size (in megabytes) of the frame-relay device";
        default = 32;
        type = lib.types.ints.positive;
      };
    };

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

    settings = lib.mkOption {
      description = "Looking Glass client configuration";
      default = {};
      type = lib.types.submodule ./types/config/config.nix;
    };
  };

  config = lib.mkIf cfg.enable {
    # Install looking glass
    environment.systemPackages = [cfg.package];

    # Create the configuration file if requested
    environment.etc."looking-glass-client.ini" = {
      text = lib.generators.toINI {} cfg.settings;
    };

    # Ensure that kvmfr device files are owned by the correct user/group
    services.udev.extraRules = if cfg.kvmfr.enable then ''
      SUBSYSTEM=="kvmfr", OWNER="${cfg.kvmfr.owner}", GROUP="kvm", MODE="0600"
    '' else "";

    # Enable and load the kvmfr module at boot
    boot.kernelModules = if cfg.kvmfr.enable then ["kvmfr"] else [];
    boot.extraModulePackages = if cfg.kvmfr.enable then [cfg.kvmfr.package] else [];
    boot.kernelParams = if cfg.kvmfr.enable then ["kvmfr.static_size_mb=${builtins.toString cfg.kvmfr.sizeMB}"] else [];

    # Have systemd pre-create the shared memory file
    systemd.tmpfiles.rules = if !cfg.shm.enable then [
      "f /dev/shm/${cfg.shm.name} 0660 ${cfg.shm.owner} qemu-libvirtd -"
    ] else [];
  };
}
