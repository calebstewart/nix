# Raspberry Pi 4 Configuration
This host runs on a Raspberry Pi 4. It can be used normally from the Raspberry Pi itself, but
the main flake also has a `packages.x86_64-linux.rpi4-sdcard` output which can be used to build
a pre-installed SD card image for a Raspberry Pi 4 with this configuration already applied.
In theory, you could build this from any system, but currently the output is only for x86-64.
You need to enable `aarch64-linux` in your binfmt emulated systems to build aarch64 packages
from `x86_64-linux`.

The initial password for the user will be `raspberry` as is traditional for Raspberry Pis. All
graphical applications are disabled for this configuration.

## Building and flashing the SD Image

```sh
# Build the system (or use `nom` for pretty output)
nix build .#rpi4-sdcard

# Write the built SD image to your SD card
zstdcat ./result/sd-image/nixos-sd-image-*.img.zst | pv | doas dd of=$SDCARD_DEVICE
```

## Problems
Currently, the only way to build the SD image is to use `qemu-user` emulation to cross-build
packages. This works, but is much slower than traditional cross compilation. In theory, you
can set the `pkgs` and `lib` arguments to `nixosGenerate` to a `pkgsCross` version of Nixpkgs
in order to do a real cross compilation like:

```nix
packages.x86_64-linux.rpi-sdcard = inputs.nixos-generators.nixosGenerate rec {
    system = "aarch64-linux";
    format = "sd-aarch64";
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux.pkgsCross.aarch64-multiplatform;
    lib = pkgs.lib;
    modules = linuxModules {
        inherit user;
        hostname = "rpi4";
        system = "aarch64-linux";
    };
};
```

This will work, but there are two problems:

1. This doesn't use the NixOS package cache, so you end up building a lot of packages from source.
2. The resulting system packages have the system tuple appended to the name. When proceeding to update
   and re-apply your configuration on the device itself, you end up reinstalling all packages and
   replacing the cross-built packages with the native ones. This isn't an issue per-se, but shouldn't
   be necessary if the cross builds are of the same locked nixpkgs version.
