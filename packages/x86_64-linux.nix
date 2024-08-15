{pkgs, ...}: with pkgs; [
  neofetch
  pw-volume
  vesktop
  remmina
  wireguard-tools
  signal-desktop
  pv
  linux-manual
  man-pages
  man-pages-posix
  devenv
  (retroarch.override {
    cores = with libretro; [
      mgba
    ];
  })
  btop

  (writeShellScriptBin "run0" ''
    exec ${systemd}/bin/run0 --setenv=LOCALE_ARCHIVE $@
  '')
]
