{inputs, lib, ...}: {
  imports = ["${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"];

  nixpkgs = {
    # Required to build the RPi kernel
    # See: https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243
    overlays =[(final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // {allowMissing = true;});
    })];
  };

  # Ensure that zfs isn't included because we don't want to compile it
  boot.supportedFilesystems = lib.mkForce ["ext4" "vfat"];
}
