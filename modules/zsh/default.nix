{pkgs, lib, config, inputs, ...}:
let
  cfg = config.modules.zsh;

  # Override the any-nix-shell package with my custom fork, which
  # implements support for the 'nix develop' command.
  any-nix-shell = pkgs.any-nix-shell.overrideAttrs {
    src = inputs.any-nix-shell;
  };
in {
  options.modules.zsh = {enable = lib.mkEnableOption "zsh";};

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        vim = "nvim";
      };

      # Initialize any-nix-shell during zsh startup
      initExtra = ''
        ${any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
      '';

      plugins = [
        {
          name = "spaceship-prompt";
          file = "lib/spaceship-prompt/spaceship.zsh";
          src = "${pkgs.spaceship-prompt}";
        }
      ];
    };
  };
}
