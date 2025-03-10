{inputs, system, ...}:
let
  # nikstur-pkgs = inputs.nikstur-nixpkgs.legacyPackages.${system};
in [
  inputs.nur.overlays.default
  # (final: prev: with nikstur-pkgs; {
  #   systemd = systemd;
  # })

  (final: prev: {
    steam = prev.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  })
]
