{inputs, system, ...}:
let
  # nikstur-pkgs = inputs.nikstur-nixpkgs.legacyPackages.${system};
in [
  inputs.nur.overlay
  # (final: prev: with nikstur-pkgs; {
  #   systemd = systemd;
  # })
  (final: prev: {
    openldap = prev.openldap.overrideAttrs (_: { doCheck = false; });
  })
]
