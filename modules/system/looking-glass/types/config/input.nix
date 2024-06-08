{lib, ...}:
let
  typeYesNo = lib.types.addCheck lib.types.str (x: (x == "yes" || x == "no"));
in {
  options = {
    grabKeyboard = lib.mkOption {
      description = "Grab the keybaord in capture mode";
      default = "yes";
      type = typeYesNo;
    };

    grabKeyboardOnFocus = lib.mkOption {
      description = "Grab the keyboard when focused";
      default = "no";
      type = typeYesNo;
    };

    releaseKeysOnFocusLoss = lib.mkOption {
      description = "On focus loss, send key up events to guest for all held keys";
      default = "yes";
      type = typeYesNo;
    };

    escapeKey = lib.mkOption {
      description = "Specify the escape/menu key to use";
      default = "KEY_SCROLLLOCK";
      type = import ./keys.nix {
        inherit lib;
      };
    };

    ignoreWindowsKeys = lib.mkOption {
      description = "Do not pass events for the windows keys to the guest";
      default = "no";
      type = typeYesNo;
    };

    hideCursor = lib.mkOption {
      description = "Hide the local mouse cursor";
      default = "yes";
      type = typeYesNo;
    };

    mouseSens = lib.mkOption {
      description = "Initial mouse sensitivity when in capture mode (-9 to 9)";
      default = 0;
      type = lib.types.addCheck lib.types.int (x: x >= -9 && x <= 9);
    };

    mouseSmoothing = lib.mkOption {
      description = "Apply simple mouse smoothing when rawMouse is not in use";
      default = "yes";
      type = typeYesNo;
    };

    rawMouse = lib.mkOption {
      description = "Use RAW mouse input when in capture mode (good for gaming)";
      default = "no";
      type = typeYesNo;
    };

    mouseRedraw = lib.mkOption {
      description = "Mouse movements trigger redraws (ignore FPS minimum)";
      default = "yes";
      type = typeYesNo;
    };

    autoCapture = lib.mkOption {
      description = "Try to keep the mouse captured when needed";
      default = "no";
      type = typeYesNo;
    };

    captureOnly = lib.mkOption {
      description = "Only enable input via SPICE if in capture mode";
      default = "no";
      type = typeYesNo;
    };

    helpMenuDelay = lib.mkOption {
      description = "Show help menu after holding down the escape key for this many milliseconds";
      default = 200;
      type = lib.types.ints.positive;
    };
  };
}
