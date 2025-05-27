{pkgs, ...}: with pkgs; [
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
  google-chrome

  (writeShellScriptBin "run0" ''
    exec ${systemd}/bin/run0 --setenv=LOCALE_ARCHIVE $@
  '')
]
