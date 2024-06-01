{lib, config, pkgs, ...}:
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
      
      globals = {
        mapleader = " ";
        transparent_enabled = true;
      };

      # Neovim options
      opts = {
        number = true;
        relativenumber = true;
        expandtab = true;
        termguicolors = true;
        shiftwidth = 2;
        tabstop = 2;
        softtabstop = 2;

        ignorecase = true;
        smartcase = true;
        signcolumn = "yes";
        cursorline = true;
        ruler = true;
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
        nix.enable = true;
        bufferline.enable = true;
        lualine.enable = true;
        lsp-format.enable = true;
        oil.enable = true;
        treesitter.enable = true;
        cmp-nvim-lsp-signature-help.enable = true;
      };

      # Toggle-able terminal emulators within Neovim!
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
          rust-analyzer.enable = true;
        };
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

      # Setup none-ls for LSP features from external tools
      plugins.none-ls = {
        enable = true;
        enableLspFormat = true;
      };

      # Install telescope because it's pretty :)
      plugins.telescope = {
        enable = true;

        extensions = {
          fzf-native.enable = true;
        };
      };

      # Alpha provides a nice dashboard if no file is opened
      plugins.alpha = {
        enable = true;
        theme = "dashboard";
        iconsEnabled = true;
      };

      # Setup neotree for a file browser bar
      plugins.neo-tree = {
        enable = true;
        enableDiagnostics = true;
        enableGitStatus = true;
        enableModifiedMarkers = true;
        enableRefreshOnWrite = true;
        closeIfLastWindow = true;
        popupBorderStyle = "rounded";

        window = {
          mappings = {
            "<space>" = "none";
          };
        };
      };

      extraPlugins = with pkgs.vimPlugins; [
        vim-bbye # bbye provides nicer Bwipeout which doesn't close the window
        transparent-nvim
      ];

      keymaps = [
        # Toggle the file explorer
        {
          key = "<leader>of";
          action = "<cmd>Neotree toggle<CR>";
        }

        # Toggle the terminal
        {
          key = "<leader>ot";
          action = "<cmd>ToggleTerm<CR>";
        }

        # Close the current buffer
        {
          key = "<leader>bd";
          action = "<cmd>Bwipeout<CR>";
        }

        # Close all buffers
        {
          key = "<leader>bK";
          action = "<cmd>bufdo :Bwipeout<CR>";
        }

        # Move to the previous buffer
        {
          key = "<leader>bh";
          action = "<cmd>bprevious<CR>";
        }

        # Move to the next buffer
        {
          key = "<leader>bl";
          action = "<cmd>bnext<CR>";
        }

        # Swap between the two most recent buffers (either j or k)
        {
          key = "<leader>bk";
          action = "<cmd>b#<CR>";
        }
        {
          key = "<leader>bj";
          action = "<cmd>b#<CR>";
        }

        # Move to the next window to the left
        {
          key = "<leader>wh";
          action = "<cmd>wincmd h<CR>";
        }

        # Move to the next window down
        {
          key = "<leader>wj";
          action = "<cmd>wincmd j<CR>";
        }

        # Move to the next window up
        {
          key = "<leader>wk";
          action = "<cmd>wincmd k<CR>";
        }

        # Move to the next window right
        {
          key = "<leader>wl";
          action = "<cmd>wincmd l<CR>";
        }
      ];
    };
  };
}
