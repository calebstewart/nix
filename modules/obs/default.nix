{pkgs, lib, config, ...}:
let
  cfg = config.modules.obs;
in {
  options.modules.obs = { enable = lib.mkEnableOption "obs"; };

  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        obs-vaapi
        obs-pipewire-audio-capture
        obs-gstreamer
      ];
    };

    home.packages = with pkgs.gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gst-libav
      gst-vaapi
    ] ++ [
      pkgs.libva
    ];
  };
}
