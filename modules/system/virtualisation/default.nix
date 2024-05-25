{lib, config, pkgs, inputs, user, ...}:
let
  cfg = config.modules.virtualisation;
in {
  options.modules.virtualisation = {
    enable = lib.mkEnableOption "virtualisation";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;

        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd];
        };
      };
    };

    environment.etc = {
      "libvirt/hooks/qemu" = {
        source = "${inputs.vfio-hooks}/libvirt_hooks/qemu";
      };
    };

    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      looking-glass-client
    ];

    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 ${user.name} qemu-libvirtd -"
    ];
  };
}
