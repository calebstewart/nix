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
    settings.auto-optimise-store = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  system = {
    defaults.dock = {
      autohide = true;
    };

    defaults.NSGlobalDomain._HIHideMenuBar = true;
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
  };

  security.pam.enableSudoTouchIdAuth = true;

  services.yabai = {
    enable = true;
    enableScriptingAddition = true;

    config = {
      focus_follows_mouse = "autoraise";
      mouse_follows_focus = "off";
      window_placement = "second_child";
      layout = "bsp";
      menubar_opacity = 0.0;
      window_gap = 4;
      top_padding = 4;
      bottom_padding = 4;
      left_padding = 4;
      right_padding = 4;
      window_opacity = "on";
      active_window_opacity = "1.0";
      normal_window_opacity = "0.95";
    };

    extraConfig = ''
      yabai -m space --create
      yabai -m space --create
      yabai -m space --create
      yabai -m space --create
      yabai -m space --create
      yabai -m space --create
      yabai -m space --create
      yabai -m space --create
      yabai -m space --create
    '';
  };

  services.skhd = {
    enable = true;
    
    skhdConfig = ''
      alt - return : alacritty

      alt - 1 : yabai -m space --focus 1
      alt - 2 : yabai -m space --focus 2
      alt - 3 : yabai -m space --focus 3
      alt - 4 : yabai -m space --focus 4
      alt - 5 : yabai -m space --focus 5
      alt - 6 : yabai -m space --focus 6
      alt - 7 : yabai -m space --focus 7
      alt - 8 : yabai -m space --focus 8
      alt - 9 : yabai -m space --focus 9
      alt - 0 : yabai -m space --focus 10

      shift + alt - 1 : yabai -m window --space 1
      shift + alt - 2 : yabai -m window --space 2
      shift + alt - 3 : yabai -m window --space 3
      shift + alt - 4 : yabai -m window --space 4
      shift + alt - 5 : yabai -m window --space 5
      shift + alt - 6 : yabai -m window --space 6
      shift + alt - 7 : yabai -m window --space 7
      shift + alt - 8 : yabai -m window --space 8
      shift + alt - 9 : yabai -m window --space 9
      shift + alt - 0 : yabai -m window --space 10
    '';
  };

  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      roboto
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };
}

