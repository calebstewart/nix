{lib, config, pkgs, ...}:
let
  cfg = config.modules.swaync;
in {
  options.modules.swaync = {
    enable = lib.mkEnableOption "swaync";
  };

  config = lib.mkIf cfg.enable {
    home.file.".config/hypr/config.d/10-swaync.conf".text = ''
      bind=$mod,N,exec,swaync-client -t -sw

      windowrulev2 = animation slide left,initialclass:(SwayNotificationCenterControlCenter)
    '';
  
    services.swaync = {
      enable = true;

      settings = {
        positionX = "right";
        positionY = "top";
        control-center-positionX = "right";
        control-center-positionY = "top";
        control-center-margin-top = 8;
        control-center-margin-bottom = 8;
        control-center-margin-right = 8;
        control-center-margin-left = 8;
        control-center-width = 500;
        control-center-height = 600;
        fit-to-screen = false;

        layer = "overlay";
        control-center-layer = "overlay";
        cssPriority = "user";
        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
        notification-inline-replies = true;
        timeout = 10;
        timeout-low = 5;
        timeout-critical = 0;
        notification-window-width = 500;
        keyboard-shortcuts = true;
        image-visibility = "when-available";
        transition-time = 200;
        hide-on-clear = true;
        hide-on-action = true;
        script-fail-notify = true;

        widgets = [
          "inhibitors"
          "title"
          "dnd"
          "mpris"
          "notifications"
        ];

        widget-config = {
          inhibitors = {
            text = "Inhibitors";
            button-text = "Clear All";
            clear-all-button = true;
          };

          mpris = {
            image-size = 96;
            image-radius = 12;
          };

          title.text = "Notifications";
          dnd.text = "Do Not Disturb";
          label.text = "Label Text";
        };

        scripts = let
          play = sound: "${pkgs.sox}/bin/play --volume 0.5 ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/${sound}.oga";
        in {
          notification-sound = {
            exec = play "message";
          };
        };
      };
    };
  };
}
