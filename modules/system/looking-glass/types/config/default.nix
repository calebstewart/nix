{config, lib, ...}:
let
  typeYesNo = lib.types.addCheck lib.types.str (x: (x == "yes" || x == "no"));
in {
  options = {
    app = lib.mkOption {
      description = "Application-wide configuration";
      default = {};
      type = lib.types.submoduleWith {
        modules = [./app.nix];
        specialArgs.typeYesNo = typeYesNo;
      };
    };

    win = lib.mkOption {
      description = "Window configuration";
      default = {};
      type = lib.types.submoduleWith {
        modules = [./win.nix];
        specialArgs.typeYesNo = typeYesNo;
      };
    };

    input = lib.mkOption {
      description = "Input configuration";
      default = {};
      type = lib.types.submoduleWith {
        modules = [./input.nix];
        specialArgs.typeYesNo = typeYesNo;
      };
    };

    spice = lib.mkOption {
      description = "Spice agent configuration";
      default = {};
      type = lib.types.submoduleWith {
        modules = [./spice.nix];
        specialArgs.typeYesNo = typeYesNo;
      };
    };
    
    audio = lib.mkOption {
      description = "Audio configuration";
      default = {};
      type = lib.types.submoduleWith {
        modules = [./audio.nix];
        specialArgs.typeYesNo = typeYesNo;
      };
    };

    egl = lib.mkOption {
      description = "EGL configuration";
      default = {};
      type = lib.types.submoduleWith {
        modules = [./egl.nix];
        specialArgs.typeYesNo = typeYesNo;
      };
    };

    opengl = lib.mkOption {
      description = "OpenGL configuration";
      default = {};
      type = lib.types.submoduleWith {
        modules = [./opengl.nix];
        specialArgs.typeYesNo = typeYesNo;
      };
    };

    wayland = lib.mkOption {
      description = "Wayland configuration";
      default = {};
      type = lib.types.submoduleWith {
        modules = [./wayland.nix];
        specialArgs.typeYesNo = typeYesNo;
      };
    };
  };
}
