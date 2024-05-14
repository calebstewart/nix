{pkgs, lib, config, ...}:
with lib;
let
  cfg = config.modules.zsh;
in {
  options.modules.zsh = {enable = mkEnableOption "zsh";};

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zsh
      spaceship-prompt
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        system-rebuild = "cd ~/git/dotfiles && doas nixos-rebuild switch --flake .";
	vim = "nvim";
      };

      plugins = [
        {
	  name = "spaceship-prompt";
	  file = "spaceship.zsh";
	  src = pkgs.fetchFromGitHub {
	    owner = "spaceship-prompt";
	    repo = "spaceship-prompt";
	    rev = "v4.15.2";
	    sha256 = "sha256-T5tilMwRc0vbj6Cq3xSf9Q77UfX2aQ+Y1RdkYtzD0k8=";
	  };
	}
      ];
    };
  };
}
