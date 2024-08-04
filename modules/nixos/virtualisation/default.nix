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

    # Allow outbound connections from VMs to things like 8000, 8080,
    # 9090 or 8443. These are normally temporary web servers or the like.
    networking.firewall.interfaces."virbr0".allowedTCPPortRanges = [
      { from = 8000; to = 10000; }
    ];
  };
}
