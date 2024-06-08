{config, lib, ...}: {
  options = {
    app = lib.mkOption {
      description = "Application-wide configuration";
      default = {};
      type = lib.types.submoduleWith {
        modules = [./app.nix];
        specialArgs.lib = lib;
      };
    };

    win = lib.mkOption {
      description = "Window configuration";
      default = {};
      type = lib.types.submoduleWith {
        modules = [./win.nix];
        specialArgs.lib = lib;
      };
    };

    input = lib.mkOption {
      description = "Input configuration";
      default = {};
      type = lib.types.submoduleWith {
        modules = [./input.nix];
        specialArgs.lib = lib;
      };
    };

    # spice = lib.mkOption {
    #   description = "Spice agent configuration";
    #   default = {};
    #   type = lib.types.submoduleWith {
    #     modules = [./spice.nix];
    #     specialArgs.lib = lib;
    #   };
    # };
    # 
    # audio = lib.mkOption {
    #   description = "Audio configuration";
    #   default = {};
    #   type = lib.types.submoduleWith {
    #     modules = [./audio.nix];
    #     specialArgs.lib = lib;
    #   };
    # };

    # egl = lib.mkOption {
    #   description = "EGL configuration";
    #   default = {};
    #   type = lib.types.submoduleWith {
    #     modules = [./egl.nix];
    #     specialArgs.lib = lib;
    #   };
    # };

    # opengl = lib.mkOption {
    #   description = "OpenGL configuration";
    #   default = {};
    #   type = lib.types.submoduleWith {
    #     modules = [./opengl.nix];
    #     specialArgs.lib = lib;
    #   };
    # };

    # wayland = lib.mkOption {
    #   description = "Wayland configuration";
    #   default = {};
    #   type = lib.types.submoduleWith {
    #     modules = [./wayland.nix];
    #     specialArgs.lib = lib;
    #   };
    # };
  };
}
