{lib, config, pkgs, ...}:
let
  cfg = config.modules.aerospace;
  toml = pkgs.formats.toml {};
in {
  options.modules.aerospace = {
    enable = lib.mkEnableOption "aerospace";

    package = lib.mkPackageOption pkgs "aerospace" {
      default = ["aerospace"];
      example = "pks.aerospace";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package pkgs.raycast];

    launchd.agents.aerospace = {
      enable = true;

      config = {
        ProgramArguments = ["${cfg.package}/Applications/AeroSpace.app/Contents/MacOS/AeroSpace"];
        KeepAlive = true;
        RunAtLoad = true;
      };
    };

    xdg.configFile."aerospace/aerospace.toml".source = toml.generate "aerospace.toml" {
      start-at-login = false;
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "horizontal";
      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      automatically-unhide-macos-hidden-apps = true;
      key-mapping.preset = "qwerty";

      gaps.inner = {
        horizontal = 5;
        vertical = 5;
      };

      gaps.outer = {
        left = 0;
        bottom = 0;
        top = 0;
        right = 0;
      };

      mode.main.binding = {
        alt-d = "exec-and-forget open -a \"Raycast\"";
        alt-enter = "exec-and-forget open -na alacritty";

        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        alt-minus = "resize smart -50";
        alt-equal = "resize smart +50";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";

        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        alt-shift-semicolon = "mode service";
      };

      mode.service.binding = {
        esc = ["reload-config" "mode main"];
        r = ["flatten-workspace-tree" "mode main"];
        f = ["layout floating tiling" "mode main"];
        backspace = ["close-all-windows-but-current" "mode main"];
      };
    };
  };
}
