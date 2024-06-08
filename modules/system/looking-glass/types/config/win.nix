{lib, typeYesNo, ...}: {
  options = {
    title = lib.mkOption {
      description = "Window Title";
      default = "Looking Glass (client)";
      type = lib.types.str;
    };

    position = lib.mkOption {
      description = "Initial window position at startup";
      default = "center";
      type = lib.types.str;
    };

    size = lib.mkOption {
      description = "Initial window size at startup";
      default = "1024x768";
      type = lib.types.str;
    };

    autoResize = lib.mkOption {
      description = "Auto resize the window to the guest";
      default = "no";
      type = typeYesNo;
    };

    allowResize = lib.mkOption {
      description = "Allow the window to be resized manually";
      default = "yes";
      type = typeYesNo;
    };

    keepAspect = lib.mkOption {
      description = "Maintain correct aspect ratio";
      default = "yes";
      type = typeYesNo;
    };

    forceAspect = lib.mkOption {
      description = "Force the window to maintain the aspect ratio";
      default = "yes";
      type = typeYesNo;
    };

    dontUpscale = lib.mkOption {
      description = "Never try to upscale the window";
      default = "no";
      type = typeYesNo;
    };

    intUpscale = lib.mkOption {
      description = "Allow only integer upscaling";
      default = "no";
      type = typeYesNo;
    };

    shrinkOnUpscale = lib.mkOption {
      description = "Limit the window dimensions when dontUpscale is enabled";
      default = "no";
      type = typeYesNo;
    };

    borderless = lib.mkOption {
      description = "Borderless mode";
      default = "no";
      type = typeYesNo;
    };
    
    fullScreen = lib.mkOption {
      description = "Launch in fullscreen borderless mode";
      default = "no";
      type = typeYesNo;
    };

    maximize = lib.mkOption {
      description = "Launch window maximized";
      default = "no";
      type = typeYesNo;
    };

    minimizeOnFocusLoss = lib.mkOption {
      description = "Minimize window on focus loss";
      default = "no";
      type = typeYesNo;
    };

    fpsMin = lib.mkOption {
      description = "Frame rate minimum (0 = disabled - not recommended, -1 = auto-detect)";
      default = -1;
      type = lib.types.addCheck lib.types.int (x: x == -1 || x >= 0);
    };

    ignoreQuit = lib.mkOption {
      description = "Ignore requests to quit (i.e. Alt+F4)";
      default = "no";
      type = typeYesNo;
    };

    noScreensaver = lib.mkOption {
      description = "Prevent the screensaver from starting";
      default = "no";
      type = typeYesNo;
    };

    autoScreensaver = lib.mkOption {
      description = "Prevent the screensaver from starting when the guest requests it";
      default = "no";
      type = typeYesNo;
    };

    alerts = lib.mkOption {
      description = "Show on screen alert messages";
      default = "yes";
      type = typeYesNo;
    };

    quickSplash = lib.mkOption {
      description = "Skip fading out the splash screen when a connection is established";
      default = "no";
      type = typeYesNo;
    };

    overlayDimsDesktop = lib.mkOption {
      description = "Dim the desktop when in interactive overlay mode";
      default = "yes";
      type = typeYesNo;
    };

    rotate = lib.mkOption {
      description = "Rotate the displayed image (0, 90, 180, 270)";
      default = 0;
      type = lib.types.int;
    };

    uiFont = lib.mkOption {
      description = "The font to use when rendering on-screen UI";
      default = "DejaVu Sans Mono";
      type = lib.types.str;
    };

    uiSize = lib.mkOption {
      description = "The font size to use when rendering on-screen UI";
      default = 14;
      type = lib.types.ints.positive;
    };

    jitRender = lib.mkOption {
      description = "Enable just-in-time rendering";
      default = "no";
      type = typeYesNo;
    };

    showFPS = lib.mkOption {
      description = "Enable the FPS and UPS display";
      default = "no";
      type = typeYesNo;
    };
  };
}
