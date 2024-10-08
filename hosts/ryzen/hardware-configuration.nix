# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = true;
  boot.initrd.services.lvm.enable = true;
  boot.initrd.supportedFilesystems = ["btrfs"];
  boot.initrd.availableKernelModules = ["xhci_pci" "nvme" "ahci" "uas" "usbhid" "sd_mod" "amdgpu" "vfio-pci"];
  boot.initrd.kernelModules = [ "dm-snapshot" "vfio-pci" ];
  boot.consoleLogLevel = 0;
  boot.kernelModules = [ "vfio-pci" "kvm-amd" ];
  boot.extraModulePackages = [];

  boot.kernelParams = [
    "quiet"
    "udev.log_level=3"
    "amd_iommu=on"
    "iommu=pt"
    "vfio-pci.ids=\"1002:744c\""
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/2da2a975-ddc4-4899-8348-be957d4f7d02";
      fsType = "btrfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5782-66AC";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp69s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp72s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp73s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
