# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, user, inputs, system, ... }:

{
  # Allow installation of non-free packages
  nixpkgs.config.allowUnfree = true;

  # Remove unecessary packages
  environment.defaultPackages = with pkgs; [
    hyprland
    looking-glass-client
  ];

  # Setup global nixos settings (mainly, enable flakes)
  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 caleb qemu-libvirtd -"
  ];

  # Configure networking with Network Manager
  networking.networkmanager.enable = true;

  # Set the default timezone
  time.timeZone = "America/New_York";

  # Configure graphical desktop manager (using GDM)
  services.xserver = {
    enable = true;
    xkb.options = "caps:swapescape";

    displayManager.gdm.enable = true;
  };

  # Enable libinput
  services.libinput.enable = true;

  # Setup default fonts
  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      roboto
      openmoji-color
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        emoji = ["OpenMoji Color"];
      };
    };
  };

  # Setup XDG portal(s)
  xdg.autostart.enable = true;
  xdg.portal = {
    enable = true;
    configPackages = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  # Install additional system packages
  environment.systemPackages = with pkgs; [
    git
    openssh
  ];

  # Use zsh as the default shell
  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.hyprland.enable = true;
  programs.virt-manager.enable = true;

  # Enable sound with pipewire support
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Setup our users
  users.users.${user.name} = {
    description = user.fullName;
    isNormalUser = true;
    extraGroups = ["wheel" "input" "networkmanager" "libvirtd"];
    createHome = true;
    shell = pkgs.zsh;
  };

  # Ensure nix enables wayland support whenever possible
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Setup useful global environment variables
  environment.variables = {
    MOZ_ENABLE_WAYLAND = "1";
    EDITOR = "nvim";
    XDG_DATA_HOME = "$HOME/.local/share";
  };

  # Setup system security settings like sudo/doas
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{
        users = [user.name];
        keepEnv = true;
        persist = true;
      }];
    };

    protectKernelImage = true;
  };

  # Enable OpenGL and bluetooth
  hardware = {
    bluetooth.enable = true;

    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/home/caleb/git/nix";

    # FIXME: Using this fork of nh which supports doas until the PR is merged:
    #        https://github.com/viperML/nh/pull/92
    package = inputs.nh-extra-privesc.packages.${system}.default;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };

  # DO NOT MODIFY
  system.stateVersion = "23.11";
}

