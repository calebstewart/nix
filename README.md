# NixOS + Home Manager configuration
This repository houses my NixOS configuration. The configuration is separated out into
individual hosts so that you can get similarly configured systems across different
hosts/hardware.

The `./hosts/{hostname}/` contains the host-specific configuration for your system.
For each hostname, there must exist a `hardware-configuration.nix` which contains
the auto-generated hardware configuration for your system, and a `user.nix` which
functions as a home-manager configuration, and normally just imports `modules/default.nix`
and enables select modules according to what features you want available on that
particular host.

If you add a new host, you should also add the hostname to `flake.nix` under `nixosConfigurations`.
The structure is simple, and only requires that the directory name under `./hosts/`
matches the value of `hostname` exactly.

## MacOS w/ Home Manager
My plan is to allow this configuration to also configure any MacOS machine I may have.
However, that requires me to build out an isolated Home Manager flake output for MacOS
systems as opposed to the system-wide NixOS configuration I currently export. I plan
to implement that once my base NixOS configurations are complete/daily-driveable.
