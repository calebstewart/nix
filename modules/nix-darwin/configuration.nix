# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, user, lib, ... }:
{
  # DO NOT MODIFY
  system.stateVersion = 4;

  imports = [];

  services.nix-daemon.enable = true;

  # Allow installation of non-free packages
  nixpkgs.config.allowUnfree = true;

  # Setup global nixos settings (mainly, enable flakes)
  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  # Enable system-wide zsh
  programs.zsh.enable = true;

  # Setup our users
  users.users.${user.name} = {
    description = user.fullName;
    home = "/Users/${user.name}";
    shell = pkgs.zsh;
  };

  environment.variables = {
    XDG_DATA_HOME = "$HOME/.local/share";
  };

}

