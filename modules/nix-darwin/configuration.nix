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
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Setup global nixos settings (mainly, enable flakes)
  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  system = {
    defaults.dock = {
      autohide = true;
    };

    # defaults.NSGlobalDomain._HIHideMenuBar = true;
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

  security.pam.enableSudoTouchIdAuth = true;

  services.yabai = {
    enable = true;

    config = {
      focus_follows_mouse = "on";
      mouse_follows_focus = "off";
      window_placement = "second_child";
      layout = "bsp";
      menubar_opacity = "0.0";
      window_gap = 4;
      window_opacity = "on";
      active_window_opacity = "1.0";
      normal_window_opacity = "0.9";
    };
  };

  services.spacebar = {
    enable = true;
    package = pkgs.spacebar;

    config = {
      position = "top";
      display = "all";
      height = 38;
    };
  };

  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      roboto
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };
}

