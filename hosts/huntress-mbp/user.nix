{user, pkgs, ...}: 
let
  firefox = pkgs.stdenv.mkDerivation rec {
    pname = "firefox";
    version = "123.0";
    sourceRoot = ".";
    phases = ["unpackPhase" "installPhase"];

    src = pkgs.stdenv.fetchurl {
      name = "Firefox-${version}.dmg";
      url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/127.0/mac/en-US/Firefox%20${version}.dmg";
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
      firefox.enable = false;

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
