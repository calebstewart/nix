# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, user, inputs, system, ... }:
let
  probe-rs-rules = pkgs.writeTextDir "etc/udev/rules.d/69-probe-rs.rules" (builtins.readFile ./69-probe-rs.rules);
  zsa-rules = pkgs.writeTextDir "etc/udev/rules.d/50-zsa.rules" (builtins.readFile ./50-zsa.rules);
in {
  # DO NOT MODIFY
  system.stateVersion = "23.11";

  imports = [
    ./virtualisation
    ./containers
    ./desktop-manager
    ./sshd
    ./users
    ./sound
    ./networking
    ./systemd-boot
    ./time
    ./security
    ./fingerprint
    ./docker
    ./looking-glass
    ./nh
    ./nordvpn
  ];

  # Allow installation of non-free packages
  nixpkgs.config.allowUnfree = true;

  # Setup global nixos settings (mainly, enable flakes)
  nix = {
    settings.trusted-users = ["root" user.name];
    settings.auto-optimise-store = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  services.udev.packages = [probe-rs-rules zsa-rules];

  services.udev.extraRules = ''
    ATTRS{idVendor}=="239a", ENV{ID_MM_DEVICE_IGNORE}="1"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="239a", MODE="0666"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="239a", MODE="0666"
  '';

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  boot.tmp.cleanOnBoot = true;

  programs.java = {
    enable = true;
    package = (pkgs.jdk21.override {
      enableJavaFX = true;
    });
  };

  documentation = {
    enable = true;
    man.enable = true;
    man.generateCaches = true;
  };

  services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.dbus.packages = [pkgs.gcr];
}

