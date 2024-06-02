# NixOS + Home Manager configuration
This repository houses my NixOS configuration. The configuration is separated out into
individual hosts so that you can get similarly configured systems across different
hosts/hardware.

The `./hosts/{hostname}/` contains the host-specific configuration for your system.
The following configurations are required for each NixOS host:

1. `hardware-configuration.nix` - This is the auto-generated hardware configuration for an individual host.
2. `configuration.nix` - This is NixOS system configuration.
3. `user.nix` - This is a Home Manager configuration for your user.

## Reinstalling an Existing Host
If you are reinstalling an existing host, you must configure your partition scheme
identically to the original setup to use this flake without changes. In that case,
after you have partitioned and mounted your file systems, you can simply run:

```sh
nixos-install --flake https://github.com/calebstewart/nix#$HOSTNAME
```

This should fully setup the system identically to the most recent `main` branch.
You will be prompted for a root password, and you should also use `nixos-enter`
to chroot into the new system, and set the primary user's password before
rebooting.

## Adding a New Host
When setting up a new piece of hardware (e.g. a new laptop), you should first boot
the machine with a NixOS installer. From there, you can partition your device 
however you like, and mount the appropriate tree under `/mnt`. Once you have
your system configured, you must generate `hardware-configuration.nix`. For this step,
follow the official NixOS manual installation steps.

Once you have a copy of `hardware-configuration.nix`, clone this repository, create
a new directory for your host, and place the hardware configuration there:

```sh
git clone https://github.com/calebstewart/nix
cd nix
mkdir hosts/$HOSTNAME/
cp /mnt/etc/nixos/hardware-configuration.nix hosts/$HOSTNAME/
cp hosts/ryzen/{configuration.nix,user.nix} hosts/$HOSTNAME/
```

You now have a starting point to edit the enabled system and user module. Finally,
you should add your host to `nixosConfigurations` and your primary user to
`homeConfigurations` within `flake.nix`.

After you have enabled/disabled the appropriate modules for your system, you can install the
system:

```sh
nixos-install --flake .#$HOSTNAME
```

At this point, the system is installed, and you can reboot. However, the primary
user has no password and their home-manager configuration is not yet applied.
You can set their password and apply their home-manager configuration with:

```sh
# This defaults to chroot-ing into /mnt
nixos-enter

# Change the primary user's password
passwd caleb

# Initialize the user's home configuration
home-manager switch --flake '.#caleb@$HOSTNAME'
```

If you didn't clone this repository under the `/mnt` mount point for your new system,
you should ensure you push any changes back to your remote prior to rebooting. Otherwise,
they will be lost to the ether as `/` is ephemeral in the context of the installation
image.

## Home Manager w/o NixOS
The home configuration for the primary user is configured separately from the system
configuration. This means it is possible to reuse this configuration on a host that
does not use NixOS. In that situation, you can use the `home-manager` command to
build and apply the configuration. You will still need a `hosts/$HOSTNAME` directory
but you will only need to provide the `user.nix` file.

In this case, you can add the primary user and your hostname to the `homeConfigurations`
variable in `flake.nix` and proceed as normal.

## Icons

| Path | Purpose | Source/Attribution |
| ---- | ------- | ------------------ |
| [equalizer.png] | Icon Used for [pwvucontrol] | <a href="https://www.flaticon.com/free-icons/mixer" title="mixer icons">Mixer icons created by Nikita Golubev - Flaticon</a> |

[equalizer.png]: ./icons/equalizer.png
[pwvucontrol]: https://github.com/saivert/pwvucontrol
