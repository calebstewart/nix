# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, user, lib, ... }:
{
  # DO NOT MODIFY
  system.stateVersion = 4;

  services.nix-daemon.enable = true;

  # Allow installation of non-free packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Setup global nixos settings (mainly, enable flakes)
  nix = {
    settings.auto-optimise-store = false;
    settings.experimental-features = ["nix-command" "flakes"];
    settings.extra-nix-path = "nixpkgs=flake:nixpkgs";
  };

  # Enable system-wide zsh
  programs.zsh.enable = true;
  services.sketchybar.enable = true;

  # Setup our users
  users.users.${user.name} = {
    description = user.fullName;
    home = "/Users/${user.name}";
    shell = pkgs.zsh;
  };

  environment.variables = {
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  environment.systemPackages = with pkgs; [
    tart
  ];

  security.pam.enableSudoTouchIdAuth = true;

  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      roboto
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };
}

