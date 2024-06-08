{lib, typeYesNo, ...}: {
  options = {
    enable = lib.mkOption {
      description = "Enable the built-in SPICE client for input and/or clipboard support";
      default = "yes";
      type = typeYesNo;
    };

    host = lib.mkOption {
      description = "The SPICE server host or UNIX socket";
      default = "127.0.0.1";
      type = lib.types.str;
    };

    port = lib.mkOption {
      description = "The SPICE server port (0 = unix socket)";
      default = 5900;
      type = lib.types.port;
    };

    input = lib.mkOption {
      description = "Use SPICE to send keyboard and mouse input events to the guest";
      default = "yes";
      type = typeYesNo;
    };

    clipboard = lib.mkOption {
      description = "Use SPICE to synchronize the clipboard contents with the guest";
      default = "yes";
      type = typeYesNo;
    };

    clipboardToVM = lib.mkOption {
      description = "Allow the clipboard to be synchronized TO the VM";
      default = "yes";
      type = typeYesNo;
    };

    clipboardToLocal = lib.mkOption {
      description = "Allow the clipbaord to be synchronized FROM the VM";
      default = "yes";
      type = typeYesNo;
    };

    audio = lib.mkOption {
      description = "Enable SPICE audio support";
      default = "yes";
      type = typeYesNo;
    };

    scaleCursor = lib.mkOption {
      description = "Scale cursor input position to screen size when up/down scaled";
      default = "yes";
      type = typeYesNo;
    };

    captureOnStart = lib.mkOption {
      description = "Capture mouse and keybaord on start";
      default = "no";
      type = typeYesNo;
    };

    alwaysShowCursor = lib.mkOption {
      description = "Always show host cursor";
      default = "no";
      type = typeYesNo;
    };

    showCursorDot = lib.mkOption {
      description = "Use a 'dot' cursor when the window does not have focus";
      default = "yes";
      type = typeYesNo;
    };
  };
}
