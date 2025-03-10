{...}: {
  # Host-specific nix-darwin configuration
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  system.keyboard.swapLeftCommandAndLeftAlt = true;
  system.keyboard.swapLeftCtrlAndFn = true;
  system.startup.chime = false;
}
