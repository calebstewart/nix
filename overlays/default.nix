{inputs, system, ...}:
let
  # nikstur-pkgs = inputs.nikstur-nixpkgs.legacyPackages.${system};
in [
  inputs.nur.overlay
  # (final: prev: with nikstur-pkgs; {
  #   systemd = systemd;
  # })
  (final: prev: {
    hyprlandPlugins.hyprsplit = prev.stdenv.mkDerivation {
      pname = "hyprsplit";
      version = "0.1";
      src = inputs.hyprsplit;

      nativeBuildInputs = with prev; [pkg-config meson ninja];
      buildInputs = with prev; [
        hyprland.dev
        pixman
        libdrm
      ] ++ hyprland.buildInputs;

      meta = with prev.lib; {
        homepage = "https://github.com/shezdy/hyprsplit";
        description = "Hyprland plugin for separate sets of workspaces on each monitor";
        license = licenses.bsd3;
        platforms = platforms.linux;
      };
    };
  })
]
