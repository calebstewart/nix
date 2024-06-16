{lib, config, pkgs, ...}:
let
  cfg = config.modules.sound;
in {
  options.modules.sound = {
    enable = lib.mkEnableOption "sound";
  };

  config = lib.mkIf cfg.enable {
    sound.enable = true;

    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    programs.noisetorch = {
      enable = true;

      
      package = pkgs.noisetorch.overrideAttrs (oldAttrs: {
        GOFLAGS = oldAttrs.GOFLAGS ++ ["-tags=nucular_shiny"];
      });
    };
  };
}
