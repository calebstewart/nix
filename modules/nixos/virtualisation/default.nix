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
          packages = with pkgs; [OVMFFull.fd];
        };
      };
    };

    environment.etc = {
      "libvirt/hooks/qemu" = {
        source = "${inputs.vfio-hooks}/libvirt_hooks/qemu";
      };
    };

    programs.virt-manager.enable = true;
  };
}
