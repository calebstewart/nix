{pkgs, ...}: with pkgs; [
  slack
  zoom-us
  neofetch
  pw-volume
  vesktop
  remmina
  wireguard-tools
  pv
  linux-manual
  man-pages
  man-pages-posix
  devenv
  btop
  gimp
  terraform

  (writeShellScriptBin "run0" ''
    exec ${systemd}/bin/run0 --setenv=LOCALE_ARCHIVE $@
  '')
]
