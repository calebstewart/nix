# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, user, inputs, system, ... }:
{
  # DO NOT MODIFY
  system.stateVersion = "23.11";

  nixpkgs.overlays = [
    (self: super: {
      pwvucontrol = super.pwvucontrol.overrideAttrs (old: rec {
        version = "0.4.1";

        src = super.fetchFromGitHub {
          owner = "saivert";
          repo = "pwvucontrol";
          rev = "0.4.1";
          sha256 = "sha256-soxB8pbbyYe1EXtopq1OjoklEDJrwK6od4nFLDwb8LY=";
        };

        cargoDeps = super.rustPlatform.importCargoLock {
          lockFile = "${src}/Cargo.lock";
          outputHashes = {
            "wireplumber-0.1.0" = "sha256-+LZ8xKok2AOegW8WvfrfZGXuQB4xHrLNshcTOHab+xQ=";
          };
        };
      });
    })
  ];

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
  ];

  # Allow installation of non-free packages
  nixpkgs.config.allowUnfree = true;

  # Setup global nixos settings (mainly, enable flakes)
  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  # Enable the nix helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/home/caleb/git/nix";

    # FIXME: Using this fork of nh which supports doas until the PR is merged:
    #        https://github.com/viperML/nh/pull/92
    package = inputs.nh-extra-privesc.packages.${system}.default;
  };
}

