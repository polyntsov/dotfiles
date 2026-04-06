{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.my.neovim;

  themeLua = pkgs.writeText "nix-theme.lua" ''
    vim.opt.termguicolors = true
    vim.opt.background = "${cfg.background}"
    vim.cmd.colorscheme("${cfg.colorscheme}")
    vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "None" })
    vim.api.nvim_set_hl(0, "@lsp.type.parameter", { fg = "None" })
  '';
in
{
  options.my.neovim = {
    enable = lib.mkEnableOption "Neovim with theme support";

    colorscheme = lib.mkOption {
      type = lib.types.str;
      description = "Neovim colorscheme name";
    };

    background = lib.mkOption {
      type = lib.types.str;
      default = "dark";
      description = "Neovim background (dark or light)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      # We let lazy.nvim manage the plugins instead of Nix.
      extraConfig = builtins.readFile ./init.vim;
    };

    # Mirror the lua configuration exactly
    xdg.configFile."nvim/lua" = {
      source = ./lua;
      recursive = true;
    };

    # Generated theme file from Nix
    xdg.configFile."nvim/lua/nix-theme.lua".source = themeLua;

    # LSP Servers and tools for Neovim
    home.packages = with pkgs; [
      clang-tools
      pyright
      ruff
      rust-analyzer
    ];
  };
}
