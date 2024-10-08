# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.systemd.enable = true;
  boot.initrd.services.lvm.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
