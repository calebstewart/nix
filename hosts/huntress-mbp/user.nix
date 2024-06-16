{user, pkgs, ...}: 
let
  firefox = pkgs.stdenv.mkDerivation rec {
    pname = "firefox";
    version = "127.0";
    sourceRoot = ".";
    phases = ["unpackPhase" "installPhase"];

    src = pkgs.fetchurl {
      name = "Firefox-${version}.dmg";
      url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
      sha256 = "sha256-PDDLyK4q0NxErDKiZshxvQhmyiwodrRkyGGTrl/+bm0=";
    };

    buildInputs = with pkgs; [
      undmg
    ];
  
    installPhase = ''
      mkdir -p "$out/Applications"
      cp -r Firefox.app "$out/Applications/Firefox.app";
    '';
  };
in {
  imports = [
    ../../modules/default.nix
  ];

  config = {
    modules = {
      # Graphical User Interface (GUI)
      firefox.enable = true;
      alacritty.enable = true;

      # Command Line Interface (CLI)
      neovim.enable = true;
      zsh.enable = true;
      git.enable = true;
      golang.enable = true;
      zoxide.enable = true;
      bat.enable = true;
      eza.enable = true;
      # gpg.enable = true;
      # direnv.enable = true;

      # System
      # xdg.enable = true;
      # packages.enable = true;
    };

    # Replace the firefox package with our custom derivation
    programs.firefox.package = firefox;
  };
}
