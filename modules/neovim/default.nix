{lib, config, ...}:
let
  cfg = config.modules.neovim;
  mkIf = lib.mkIf;
  mkEnableOption = lib.mkEnableOption;
in {
  options.modules.neovim = {enable = mkEnableOption "neovim";};

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      colorschemes.base16.enable = true;

      # Neovim options
      opts = {
        number = true;
        relativenumber = true;
        expandtab = true;
        termguicolors = true;
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;
      };

      # Use whatever color scheme was selected for the system. This is
      # normally just a nix-colors base16 palette, which means we could
      # set base16.colorscheme to config.colorScheme.slug, but in the
      # event we use a non-standard base16 scheme, that will fail.
      # instead, we set the scheme manually.
      colorschemes.base16.colorscheme = with config.colorScheme.palette; {
        base00 = "#${base00}";
        base01 = "#${base01}";
        base02 = "#${base02}";
        base03 = "#${base03}";
        base04 = "#${base04}";
        base05 = "#${base05}";
        base06 = "#${base06}";
        base07 = "#${base07}";
        base08 = "#${base08}";
        base09 = "#${base09}";
        base0A = "#${base0A}";
        base0B = "#${base0B}";
        base0C = "#${base0C}";
        base0D = "#${base0D}";
        base0E = "#${base0E}";
        base0F = "#${base0F}";
      };

      # Enable cliboard support with the default register
      clipboard = {
        providers.wl-copy.enable = true;
        register = "unnamedplus";
      };

      # Enable common plugins with no extra configuration
      plugins = {
        lualine.enable = true;
        lsp-format.enable = true;
      };

      plugins.toggleterm = {
        enable = true;

        settings = {
          direction = "horizontal";
          hide_numbers = true;
        };
      };

      # Setup Language Servers
      plugins.lsp = {
        enable = true;

        servers = {
          lua-ls.enable = true;
          gopls.enable = true;
          nixd.enable = true;
          pyright.enable = true;
          clangd.enable = true;
        };
      };

      plugins.cmp-nvim-lsp-signature-help.enable = true;

      plugins.treesitter = {
        enable = true;
      };

      # Setup auto-completion
      plugins.cmp = {
        enable = true;
        autoEnableSources = true;

        settings.sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
        ];
      };

      plugins.none-ls = {
        enable = true;
        enableLspFormat = true;
      };
    };
  };
}
