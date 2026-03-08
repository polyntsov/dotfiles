{ pkgs, ... }:

{
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

  # LSP Servers and tools for Neovim
  home.packages = with pkgs; [
    clang-tools
    pyright
    rust-analyzer
  ];
}
