{pkgs, lib, config, ...}:
let
  cfg = config.modules.zsh;
in {
  options.modules.zsh = {enable = lib.mkEnableOption "zsh";};

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        system-rebuild = "doas nixos-rebuild switch --flake ~/git/nix";
        vim = "nvim";
      };

      plugins = [
        {
          name = "spaceship-prompt";
          file = "lib/spaceship-prompt/spaceship.zsh";
          src = "${pkgs.spaceship-prompt}";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = "${pkgs.zsh-nix-shell}";
        }
      ];
    };
  };
}
